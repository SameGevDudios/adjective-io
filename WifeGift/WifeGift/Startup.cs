using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using WifeGift.DataAccess.Repositories;
using WifeGift.DataAccess.Contexts;
using WifeGift.DataAccess.Models;
using WifeGift.DataAccess.DbInitializiation;

namespace WifeGift.Startup
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers().AddMvcOptions(x =>
                x.SuppressAsyncSuffixInActionNames = false);

            services.AddDbContext<UserDataContext>(options =>
            {
                options.UseNpgsql(Configuration.GetConnectionString("AdjectiveIoUserDataDb"));
                options.UseSnakeCaseNamingConvention();
            });

            services.AddDbContext<AuthContext>(options =>
            {
                options.UseNpgsql(Configuration.GetConnectionString("AdjectiveIoAuthDb"));
                options.UseSnakeCaseNamingConvention();
            });

            services.AddIdentity<ApplicationUser, IdentityRole>()
                .AddEntityFrameworkStores<AuthContext>()
                .AddDefaultTokenProviders();

            services.AddScoped(typeof(IRepository<>), typeof(UserDataRepository<>));

            services.AddOpenApiDocument(options =>
            {
                options.Title = "AdjectiveIo API Doc";
                options.Version = "1.0";
            });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IDbInitializer dbInitializer)
        {
            if (env.IsDevelopment())
            {
                app.UseOpenApi();
                app.UseSwaggerUi(x =>
                {
                    x.DocExpansion = "list";
                });
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints => endpoints.MapControllers());

            dbInitializer.Initialize();
        }
    }
}

using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using WifeGift.Core.Configuration.PreferenceSettings;
using WifeGift.Core.Services.ProfileService;
using WifeGift.DataAccess.Contexts;
using WifeGift.DataAccess.DbInitializiation;
using WifeGift.DataAccess.Models;
using WifeGift.DataAccess.Repositories;

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

            services.Configure<PreferenceSettings>(Configuration.GetSection("PreferenceSettings"));

            services.AddSingleton<IPreferenceSettings>(sp =>
                sp.GetRequiredService<IOptions<PreferenceSettings>>().Value);

            services.AddScoped(typeof(IRepository<>), typeof(UserDataRepository<>));

            services.AddScoped<IProfileService, ProfileService>();

            services.AddScoped<IDbInitializer, EfDbInitializer>();

            services.AddScoped<IPreferenceSettings, PreferenceSettings>();

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

            services.AddIdentityApiEndpoints<ApplicationUser>()
                .AddEntityFrameworkStores<AuthContext>();


            services.AddOpenApiDocument(options =>
            {
                options.Title = "AdjectiveIo API Doc";
                options.Version = "1.0";

                options.AddSecurity("JWT", Enumerable.Empty<string>(), new NSwag.OpenApiSecurityScheme
                {
                    Type = NSwag.OpenApiSecuritySchemeType.ApiKey,
                    Name = "Authorization",
                    In = NSwag.OpenApiSecurityApiKeyLocation.Header,
                    Description = "Insert a Bearer token"
                });
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

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();

                var versionedAuthGroup = endpoints.MapGroup("api/v1");
                versionedAuthGroup.MapIdentityApi<ApplicationUser>()
                    .WithTags("auth");
            });

            dbInitializer.Initialize();
        }
    }
}

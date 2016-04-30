package grp.uon.bliss.rest;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;

import grp.uon.bliss.helper.UrlHelper;
import grp.uon.bliss.model.BlissArticle;
import grp.uon.bliss.model.BlissMenus;
import io.realm.RealmObject;
import retrofit.Call;
import retrofit.GsonConverterFactory;
import retrofit.Retrofit;
import retrofit.http.GET;
import retrofit.http.Path;

public class ApiService {
    private static final Gson GSON = new GsonBuilder()
            .setExclusionStrategies(new ExclusionStrategy() {
                @Override
                public boolean shouldSkipField(FieldAttributes f) {
                    return f.getDeclaringClass().equals(RealmObject.class);
                }

                @Override
                public boolean shouldSkipClass(Class<?> clazz) {
                    return false;
                }
            })
            .create();

    private static final Retrofit RETROFIT = new Retrofit.Builder()
            .baseUrl(UrlHelper.getBaseApiUrl())
            .addConverterFactory(GsonConverterFactory.create(GSON))
            .build();

    private static final Service SERVICE = RETROFIT.create(Service.class);

    public static Service getService() {
        return SERVICE;
    }

    public interface Service {
        @GET("menus")
        Call<BlissMenus> getMenus();

        @GET("articles")
        Call<List<BlissArticle>> getArticles();

        @GET("article/{id}")
        Call<BlissArticle> getArticle(@Path("id") int id);

        @GET("all")
        Call<BlissMenus> getAll();
    }
}

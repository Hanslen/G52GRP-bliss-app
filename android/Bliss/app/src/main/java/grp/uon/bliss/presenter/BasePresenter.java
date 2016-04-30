package grp.uon.bliss.presenter;

import de.greenrobot.event.EventBus;
import grp.uon.bliss.event.NavDrawerItemsUpdatedEvent;
import grp.uon.bliss.model.BlissMenu;
import grp.uon.bliss.model.BlissMenus;
import grp.uon.bliss.rest.ApiService;
import grp.uon.bliss.view.activity.BaseActivity;
import io.realm.Realm;
import io.realm.RealmList;
import io.realm.RealmResults;
import retrofit.Call;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;
import timber.log.Timber;

/**
 * TODO
 * Loading from locally included JSON file on first app launch
 */
public class BasePresenter {
    private BaseActivity mView;

    private Realm mRealm;

    public BasePresenter(BaseActivity view) {
        mView = view;
        mRealm = Realm.getDefaultInstance();
    }

    /**
     * Should be called by onDestroy() in the view to close the Realm instance.
     */
    public void destroyPresenter() {
        mRealm.close();
    }

    /**
     * Checks for menu items stored locally and then calls {@link #loadMenusFromApi()}
     */
    public void loadMenuItems() {
        RealmResults<BlissMenu> result = mRealm.where(BlissMenu.class)
                .findAll();
        if (result.size() > 0) {
            RealmList<BlissMenu> menusList = new RealmList<>();
            menusList.addAll(result);
            BlissMenus blissMenus = new BlissMenus();
            blissMenus.setMenus(menusList);

            EventBus.getDefault().post(new NavDrawerItemsUpdatedEvent(blissMenus));
        }
        loadMenusFromApi();
    }

    /**
     * Loads menu items from the network and stores/updates them in the database.
     */
    public void loadMenusFromApi() {
        Call<BlissMenus> call = ApiService.getService().getMenus();
        call.enqueue(new Callback<BlissMenus>() {
            @Override
            public void onResponse(Response<BlissMenus> response, Retrofit retrofit) {
                final BlissMenus menus = response.body();
                EventBus.getDefault().post(new NavDrawerItemsUpdatedEvent(menus));

                mRealm.executeTransaction(new Realm.Transaction() {
                    @Override
                    public void execute(Realm realm) {
                        realm.copyToRealmOrUpdate(menus.getMenus());
                    }
                });
            }

            @Override
            public void onFailure(Throwable t) {
                Timber.e(t, "Error loading menu items from API");
            }
        });
    }
}

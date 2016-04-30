package grp.uon.bliss;

import android.app.Application;

import grp.uon.bliss.helper.ReleaseTreeHelper;
import io.realm.Realm;
import io.realm.RealmConfiguration;
import timber.log.Timber;

public class Bliss extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        // TODO: Crash reporting framework -- Crashlytics?
        setupTimber();
        setupRealm();
    }

    private void setupTimber() {
        if (BuildConfig.DEBUG) {
            Timber.plant(new Timber.DebugTree() {
                @Override
                protected String createStackElementTag(StackTraceElement element) {
                    return super.createStackElementTag(element) + ":" + element.getLineNumber();
                }
            });
        } else {
            Timber.plant(new ReleaseTreeHelper());
        }
    }

    private void setupRealm() {
        RealmConfiguration realmConfiguration = new RealmConfiguration.Builder(this)
                .build();
        Realm.setDefaultConfiguration(realmConfiguration);
    }
}

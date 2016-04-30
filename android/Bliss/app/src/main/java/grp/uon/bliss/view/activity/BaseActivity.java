package grp.uon.bliss.view.activity;

import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SubMenu;

import java.util.List;

import de.greenrobot.event.EventBus;
import grp.uon.bliss.R;
import grp.uon.bliss.event.NavDrawerItemsUpdatedEvent;
import grp.uon.bliss.model.BlissMenu;
import grp.uon.bliss.model.BlissSubMenu;
import grp.uon.bliss.presenter.BasePresenter;
import timber.log.Timber;

public abstract class BaseActivity extends AppCompatActivity {
    private Toolbar mToolbar;
    private DrawerLayout mDrawerLayout;
    private NavigationView mNavigationView;

    private BasePresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mPresenter = new BasePresenter(this);
        EventBus.getDefault().register(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mPresenter.destroyPresenter();
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void setContentView(int layoutResID) {
        super.setContentView(layoutResID);
        getToolbar();
        setupNavDrawer();
        mPresenter.loadMenuItems();
    }

    @Override
    public void onBackPressed() {
        if (isNavDrawerOpen()) {
            closeNavDrawer();
        } else {
            super.onBackPressed();
        }
    }

    private void setupNavDrawer() {
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mNavigationView = (NavigationView) findViewById(R.id.nav_view);
        if (mDrawerLayout == null || mNavigationView == null) {
            Timber.d("Not setting up navigation drawer, unable to find layout.");
            return;
        }

        if (mToolbar != null) {
            ActionBarDrawerToggle drawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                    mToolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
            mDrawerLayout.setDrawerListener(drawerToggle);
            if (getSupportActionBar() != null) {
                getSupportActionBar().setDisplayHomeAsUpEnabled(true);
                getSupportActionBar().setDisplayShowHomeEnabled(true);
            }
            drawerToggle.syncState();
        }
        // TODO: Loading spinner on Navigation Drawer whilst waiting to populate menus?
    }

    public void onEventMainThread(NavDrawerItemsUpdatedEvent event) {
        Menu menu = mNavigationView.getMenu();

        List<BlissMenu> blissMenus = event.getMenus().getMenus();
        for (BlissMenu blissMenu : blissMenus) {
            SubMenu subMenu = menu.addSubMenu(blissMenu.getName());

            List<BlissSubMenu> blissSubMenus = blissMenu.getSubMenus();
            if (blissSubMenus.size() > 0) {
                for (BlissSubMenu blissSubMenu : blissSubMenus) {
                    subMenu.add(blissSubMenu.getName());
                }
            } else {
                subMenu.add(blissMenu.getName());
            }
        }

        // Workaround for bug: https://code.google.com/p/android/issues/detail?id=176300
        MenuItem mi = menu.getItem(menu.size() - 1);
        mi.setTitle(mi.getTitle());
    }

    protected boolean isNavDrawerOpen() {
        return mDrawerLayout != null && mDrawerLayout.isDrawerOpen(GravityCompat.START);
    }

    protected void closeNavDrawer() {
        if (mDrawerLayout != null) {
            mDrawerLayout.closeDrawer(GravityCompat.START);
        }
    }

    protected Toolbar getToolbar() {
        if (mToolbar == null) {
            mToolbar = (Toolbar) findViewById(R.id.toolbar);
            if (mToolbar != null) {
                setSupportActionBar(mToolbar);
            }
        }
        return mToolbar;
    }
}

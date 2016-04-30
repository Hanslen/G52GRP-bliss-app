package grp.uon.bliss.event;

import grp.uon.bliss.model.BlissMenus;

public class NavDrawerItemsUpdatedEvent {
    private BlissMenus mMenus;

    public NavDrawerItemsUpdatedEvent(BlissMenus menus) {
        mMenus = menus;
    }

    public BlissMenus getMenus() {
        return mMenus;
    }
}

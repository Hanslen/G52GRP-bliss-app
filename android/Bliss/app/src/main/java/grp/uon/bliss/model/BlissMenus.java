package grp.uon.bliss.model;

import io.realm.RealmList;
import io.realm.RealmObject;

public class BlissMenus extends RealmObject {
    private RealmList<BlissMenu> menus = new RealmList<>();

    public RealmList<BlissMenu> getMenus() {
        return menus;
    }

    public void setMenus(RealmList<BlissMenu> menus) {
        this.menus = menus;
    }
}

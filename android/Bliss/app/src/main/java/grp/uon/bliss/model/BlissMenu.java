package grp.uon.bliss.model;

import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

public class BlissMenu extends RealmObject {
    @PrimaryKey
    private int id;
    private String name;
    private RealmList<BlissArticle> articles = new RealmList<>();
    private RealmList<BlissSubMenu> subMenus = new RealmList<>();

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public RealmList<BlissArticle> getArticles() {
        return articles;
    }

    public RealmList<BlissSubMenu> getSubMenus() {
        return subMenus;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setArticles(RealmList<BlissArticle> articles) {
        this.articles = articles;
    }

    public void setSubMenus(RealmList<BlissSubMenu> subMenus) {
        this.subMenus = subMenus;
    }
}

package grp.uon.bliss.model;

import io.realm.RealmList;
import io.realm.RealmObject;

public class BlissSubMenu extends RealmObject {
    private String name;
    private RealmList<BlissArticle> articles = new RealmList<>();

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public RealmList<BlissArticle> getArticles() {
        return articles;
    }

    public void setArticles(RealmList<BlissArticle> articles) {
        this.articles = articles;
    }
}

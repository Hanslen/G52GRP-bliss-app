package grp.uon.bliss.model;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

public class BlissArticle extends RealmObject {
    @PrimaryKey
    private int id;
    private String lastUpdated;
    private String title;
    private String headerImageUrl;
    private String body;

    public int getId() {
        return id;
    }

    public String getLastUpdated() {
        return lastUpdated;
    }

    public String getTitle() {
        return title;
    }

    public String getHeaderImageUrl() {
        return headerImageUrl;
    }

    public String getBody() {
        return body;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setLastUpdated(String lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setHeaderImageUrl(String headerImageUrl) {
        this.headerImageUrl = headerImageUrl;
    }

    public void setBody(String body) {
        this.body = body;
    }
}

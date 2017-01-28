package up.project.jsp;

import up.project.jsp.DBConnector;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

/**
 * Created by abdullah on 11/29/2016.
 */
public class PostsBean implements java.io.Serializable {

    private int id;
    private String title;
    private String body;
    private Date postDate;
    private int user_id;
    private String config;
    private boolean isAdmin = false;

    public PostsBean() {

    }

    public PostsBean(String config) {
        this.config = config;

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Date getPostDate() {
        return postDate;
    }

    public void setPostDate(Date postDate) {
        this.postDate = postDate;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    /**
     *
     * @param limit
     * @param offset
     * @return
     */
    public Vector getPostsWithPaginate(int limit, int offset) {
        try {
            Vector v;
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql = "";
            if (this.isAdmin) {
                sql = "SELECT `posts`.id, `posts`.title, `posts`.body, `posts`.post_date, " +
                        "CONCAT_WS(' ',users.first_name, users.last_name) AS Fullname FROM `posts` " +
                        "left join users on users.id = posts.user_id  ORDER BY `post_date` DESC  LIMIT " + limit + " OFFSET " + offset;
                v = connector.dbMultipleRowQuery(sql);
                connector.dbClose();
                return v;
            } else {
                sql = "SELECT `posts`.id, `posts`.title, `posts`.body, `posts`.post_date, " +
                        "CONCAT_WS(' ',users.first_name, users.last_name) AS Fullname FROM `posts` left join users on users.id = posts.user_id " +
                        " where user_id = '"+ this.user_id +"' ORDER BY `post_date` DESC  LIMIT " + limit + " OFFSET " + offset;
                v = connector.dbMultipleRowQuery(sql);
                connector.dbClose();
                return v;
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * @return
     */
    public String countPosts() {
        try {
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            if(isAdmin) {
                String sql = "SELECT COUNT(*) As total_post FROM `posts`";
                return connector.dbOneRowValue(sql, "total_post");
            }else{
                String sql = "SELECT COUNT(*) As total_post FROM `posts` where user_id = '"+this.user_id+"'";
                return connector.dbOneRowValue(sql, "total_post");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * @return
     */
    public boolean deletePost() {
        try {
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql ="";
            if(this.isAdmin){
                sql = "Delete From `posts` where id = " + this.id;
            }else{
                sql = "Delete From `posts` where id = " + this.id + " AND user_id = "+ this.user_id;
            }
            connector.dbDelete(sql);
            connector.dbClose();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * @return
     */
    public boolean isExist() {
        try {
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql;
            if (isAdmin) {
                sql = "select * From `posts` where id = " + this.id;
            } else {
                sql = "select * From `posts` where id = " + this.id + " and user_id = '"+this.user_id+"'";
            }
            if (connector.isExist(sql)) {
                connector.dbClose();
                return true;
            } else {
                return false;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     *
     */
    public void addPost() {
        try {
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            Date date = new Date();
            SimpleDateFormat ft = new SimpleDateFormat("y-M-d  H:m:s");
            String sql = "INSERT INTO `posts` (`title`, `body`, `post_date`, `user_id`) " +
                    "VALUES ('" + this.title + "','" + this.body + "','" + ft.format(date) + "','"+this.user_id+"')";
            connector.dbInsert(sql);
            connector.dbClose();
            connector = null;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * @return
     */
    public Vector getPost() {
        try {
            Vector v;
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql = "";
            if(isAdmin){
                sql = "SELECT * FROM `posts` where id = " + this.id + " limit 1 ";
            }else{
                sql = "SELECT * FROM `posts` where id = " + this.id + " AND user_id = "+this.user_id+" limit 1 ";
            }
            v = connector.dbOneRowQuery(sql);
            connector.dbClose();
            return v;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     *
     */
    public void updatePost(){
        try {
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql ="";
            if(isAdmin){
                sql = "update `posts` set `title` ='"+this.title+"' , `body` ='"+this.body+"' where `id` = '"+this.id+"'";
            }else{
                sql = "update `posts` set `title` ='"+this.title+"' , `body` ='"+this.body+"' where `id` = '"+this.id+"'" +
                        " and user_id = "+this.user_id ;
            }
            connector.dbUpdate(sql);
            connector.dbClose();
            connector = null;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

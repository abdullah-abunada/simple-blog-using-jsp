package up.project.jsp;

/**
 * Created by abdullah on 12/3/2016.
 */
import org.apache.commons.codec.digest.DigestUtils;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Vector;

public class UsersBean {

    private int id;
    private String email;
    private String firstName;
    private String lastName;
    private String password;
    private String avatar = "";
    private int isAdmin = 0;
    private int isActive = 0;

    private String config;

    public UsersBean(){

    }

    public UsersBean(String config){
        this.config = config;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = DigestUtils.md5Hex(password);
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int isAdmin() {
        return isAdmin;
    }

    public void setAdmin(int admin) {
        isAdmin = admin;
    }

    public int isActive() {
        return isActive;
    }

    public void setActive(int active) {
        isActive = active;
    }

    /**
     *
     * @return
     */
    public boolean logIn(){
        try {
            Vector v;
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql = "";
            sql = "SELECT `password` FROM `users` where is_active = '1' AND email = '"+ this.email +"' limit 1 ";
            v = connector.dbOneRowQuery(sql);
            if(v.isEmpty()){
                connector.dbClose();
                return false;
            }else{
                connector.dbClose();
                String userPassword = v.elementAt(0).toString();
                if(userPassword.equals(this.password)){
                    return true;
                }else{
                    return false;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }
    /**
     *
     */
    public void addUser() {
        try {
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql = "INSERT INTO `users` (`email`, `password`, `first_name`, `last_name`, `avatar`, `is_admin`, `is_active`) " +
                    "VALUES ('" + this.email + "','" + this.password + "','" + this.firstName + "', '" + this.lastName + "'" +
                    ",'" + this.avatar + "', '" + this.isAdmin + "', '" + this.isActive + "')";
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
    public Vector getUserByEmail() {
        try {
            Vector v;
            DBConnector connector = new DBConnector(this.config);
            connector.dbConnect();
            String sql = "";
            sql = "SELECT * FROM `users` where  is_active = '1' AND email = '"+ this.email +"' limit 1 ";
            v = connector.dbOneRowQuery(sql);
            connector.dbClose();
            return v;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}

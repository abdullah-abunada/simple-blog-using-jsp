package up.project.jsp;
/**
 * Created by abdullah on 11/29/2016.
 */

import java.sql.*;
import java.util.*;
import java.io.*;

public class DBConnector {

    private String host;
    private String port;
    private String user;
    private String password;
    private String database;
    private String url;
    private Connection conn;

    /**
     *
     * @param config
     * @throws IOException
     * ----------------------------------------
     * up.project.jsp.DBConnector constructor to initialize connection with db using passed config file
     */
    public DBConnector(String config) throws IOException {

        //read configuration from config file and store it in myProperties object
        Properties myProperties = new Properties();
        FileInputStream in = new FileInputStream(config);
        myProperties.load(in);
        in.close();
        //pass myProperties values to variables
        this.host = myProperties.getProperty("host");
        this.port = myProperties.getProperty("port");
        this.user = myProperties.getProperty("user");
        this.password = myProperties.getProperty("password");
        this.database = myProperties.getProperty("db");
        //initialize database url connection
        this.url = "jdbc:mysql://" + this.host + ":" + this.port + "/" + this.database;
    }

    /**
     *
     */
    public void dbConnect() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            this.conn = DriverManager.getConnection(this.url, this.user, this.password);
        } catch (SQLException ex) {
            System.out.print(ex.toString());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     */
    public void dbClose(){
        try{
            this.conn.close();
        }catch (Exception ex){
            System.out.print(ex.toString());
        }
    }

    /**
     *
     * @param sql
     * @throws SQLException
     */
    public void dbInsert(String sql)throws SQLException{
        Statement insertStmt = this.conn.createStatement();
        insertStmt.executeUpdate(sql);
        insertStmt.close();
    }

    /**
     *
     * @param sqlUpdate
     * @throws SQLException
     */
    public void dbUpdate(String sqlUpdate)throws SQLException{

        Statement updateStmt = this.conn.createStatement();
        updateStmt.executeUpdate(sqlUpdate);
        updateStmt.close();

    }

    /**
     *
     * @param sqlInsert
     * @param sqlUpdate
     */
    public void dbInsertUpdate(String sqlInsert, String sqlUpdate){
        try{
            Statement insertUpdateStmt = this.conn.createStatement();
            insertUpdateStmt.executeUpdate(sqlInsert);
            insertUpdateStmt.executeUpdate(sqlUpdate);
            insertUpdateStmt.close();
        }catch (SQLException ex){}
    }

    /**
     *
     * @param sql
     */
    public void dbDelete(String sql){
        try{
            Statement deleteStmt = this.conn.createStatement();
            deleteStmt.executeUpdate(sql);
            deleteStmt.close();
        }catch (SQLException ex){}
    }

    /**
     *
     * @param sqlQuery
     * @return
     */
    public  Vector dbOneRowQuery(String sqlQuery){
        Vector v = new Vector();
        try{
            Statement queryStmt = this.conn.createStatement();
            ResultSet rs = queryStmt.executeQuery(sqlQuery);
            int colCount = rs.getMetaData().getColumnCount();
            String s;
            while (rs.next ()){
                for(int i = 0; i < colCount; i++){
                    s = rs.getString(i+1);
                    v.addElement(s);
                }
            }
            rs.close();
            queryStmt.close();
        }catch (SQLException ex){}
        return v;
    }

    /**
     *
     * @param sqlQuery
     * @return
     */
    public  Vector dbMultipleRowQuery(String sqlQuery){
        Vector v = new Vector();
        try{
            Statement queryStmt = this.conn.createStatement();
            ResultSet rs = queryStmt.executeQuery(sqlQuery);
            int colCount = rs.getMetaData().getColumnCount();
            String s;
            while (rs.next ()){
                Vector vec = new Vector();
                for(int i = 0; i < colCount; i++){
                    s = rs.getString(i+1);
                    vec.addElement(s);
                }
                v.addElement(vec);
            }
            rs.close();
            queryStmt.close();

        }catch (SQLException ex){}
        return v;
    }

    /**
     *
     * @param sqlQuery
     * @param colName
     * @return
     */
    public String dbOneRowValue(String sqlQuery,String colName){

        String s = null;
        try{
            Statement queryStmt = this.conn.createStatement();
            ResultSet rs = queryStmt.executeQuery(sqlQuery);
            boolean b = rs.next();
            s = rs.getString(colName);
        }
        catch (SQLException ex){}
        return s;
    }

    /**
     *
     * @param sql
     * @return
     */
    public boolean isExist(String sql){
        Vector v;
        v = this.dbOneRowQuery(sql);
        if(v.isEmpty()){
            return false;
        }else {
            return true;
        }
    }
}

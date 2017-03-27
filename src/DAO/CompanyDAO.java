package DAO;

import connection.DataAccess;
import dbbeans.CompanyBean;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Created by timothysmith on 2017-03-26.
 */
public class CompanyDAO {
    static private Connection connection;
    static private Statement st;
    static private ResultSet rs;



    public static CompanyBean getCompanyById(String id) {

        CompanyBean companyBean = new CompanyBean();

        DataAccess.openConnection();
        connection = DataAccess.getConnection();

        try {
            st = connection.createStatement();
            rs = st.executeQuery("SELECT cname, companyid FROM \"Proj\".company " +
                    "WHERE companyid = '" + id + "';");
            if (rs.next()) {
                companyBean.setcName(rs.getString("cname"));
                companyBean.setCompanyId(rs.getInt("companyid"));
            }
            rs.close();
            st.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return companyBean;
    }

    public static int getAverageRating(int id) {

        int averageRating = 0;
        DataAccess.openConnection();
        connection = DataAccess.getConnection();

        try {
            st = connection.createStatement();
            rs = st.executeQuery("SELECT SUM(rating), COUNT(rating) " +
                    "FROM \"Proj\".company WHERE companyid = "
                    + id + ";");
            if (rs.next()) {
                averageRating = rs.getInt(1) / rs.getInt(2);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return averageRating;
    }

    public static ArrayList<CompanyBean> listTopFiveCompanies() {
        ArrayList<CompanyBean> companyList = new ArrayList<>();

        DataAccess.openConnection();
        connection = DataAccess.getConnection();

        try {
            st = connection.createStatement();
            rs = st.executeQuery("SELECT rating, cname, location, companyid FROM \"Proj\".company " +
                                    "ORDER BY rating DESC LIMIT 5;");
            while (rs.next()) {
                CompanyBean company = new CompanyBean();
                company.setcName(rs.getString("cname"));
                company.setLocation(rs.getString("location"));
                company.setCompanyId(rs.getInt("companyid"));

                companyList.add(company);
            }
            rs.close();
            st.close();
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return companyList;
    }

    public static CompanyBean login(CompanyBean companyBean) {
        DataAccess.openConnection();
        connection = DataAccess.getConnection();

        String companyName = companyBean.getcName();
        String password = companyBean.getPassword();
        try {
            st = connection.createStatement();
            rs = st.executeQuery("SELECT * FROM \"Proj\".company WHERE "
                    + "cname = '" + companyName + "' AND password = '" + password + "';");
            System.out.println(rs.getRow());
            if (rs.next()) {
                companyBean.setCompanyId(rs.getInt("companyid"));
                companyBean.setCompanySize(rs.getInt("companysize"));
                companyBean.setLocation(rs.getString("location"));
                companyBean.setRating( (int) rs.getDouble("rating"));
            }
            else {
                rs.close();
                st.close();
                connection.close();
                return null;
            }
        }
        catch (SQLException e) {
            e.printStackTrace();}
        return companyBean;
    }
}


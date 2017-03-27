package dbbeans;

import DAO.CompanyDAO;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Created by timothysmith on 2017-03-26.
 */
public class CompanyBean implements Serializable {
    private int companyId;
    private String password;
    private int companySize;
    private String location;
    private int rating;
    private String cName;

    public CompanyBean() {

    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getCompanySize() {
        return companySize;
    }

    public void setCompanySize(int companySize) {
        this.companySize = companySize;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getcName() {
        return cName;
    }

    public void setcName(String cName) {
        this.cName = cName;
    }


    public CompanyBean getCompanyById(String companyId) {
        return CompanyDAO.getCompanyById(companyId);
    }

    public static ArrayList<CompanyBean> listTopFiveCompanies() {
        return CompanyDAO.listTopFiveCompanies();
    }

    public int getAverageRating(String id) {
        return CompanyDAO.getAverageRating(id);
    }

    public CompanyBean login(CompanyBean companyBean) {
        return CompanyDAO.login(companyBean);
    }
}

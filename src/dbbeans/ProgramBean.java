package dbbeans;

import java.io.Serializable;

/**
 * Created by timothysmith on 2017-03-27.
 */
public class ProgramBean implements Serializable {

    private String programName;
    private String programCode;

    public ProgramBean() {

    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }

    public String getProgramCode() {
        return programCode;
    }

    public void setProgramCode(String programCode) {
        this.programCode = programCode;
    }
}

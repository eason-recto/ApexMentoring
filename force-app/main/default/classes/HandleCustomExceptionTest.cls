@IsTest
public class HandleCustomExceptionTest {

    @IsTest
    public static void CreateAccount() {
        try {
            Account m = new Account();
            insert m;
        } catch (Exception e) {
            HandleCustomException.LogException(e);
        }    
    } 
}
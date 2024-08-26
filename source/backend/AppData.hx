package backend;

#if android
import android.os.AppDetails;

class AppData
{
    public static function getVersionName():String {
        return AppDetails.getVersionName();
    }

    //public static function getPackageName():String {
        //return AppDetails.getAppPackageName();
    //}

    public static function getVersionCode():Int {
        return AppDetails.getVersionCode();
    }
}
#end

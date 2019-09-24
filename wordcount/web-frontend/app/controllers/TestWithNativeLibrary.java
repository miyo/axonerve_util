package controllers;

public class TestWithNativeLibrary {

    private long ptr = 0;

    private native void init(String bin);
    public native void add_vec(int[] x, int[] y, int[] z);
    public native void clear();

    public TestWithNativeLibrary(String bin){
        init(bin);
    }

    static {
        System.loadLibrary("test_with_native_library_jni");
    }

    public static void main(String... args){
        TestWithNativeLibrary obj = new TestWithNativeLibrary(args[0]);
        obj.clear();
        int len = 128;
        int[] x = new int[len];
        int[] y = new int[len];
        int[] z = new int[len];
        for(int i = 0; i < len; i++){
            x[i] = i;
            y[i] = i;
        }
        for(int i = 0; i < len; i++){
            System.out.println("z[" + i + "] : " + z[i]);
        }
        obj.add_vec(x, y, z);
        for(int i = 0; i < len; i++){
            System.out.println("z[" + i + "] : " + z[i]);
        }
    }



}

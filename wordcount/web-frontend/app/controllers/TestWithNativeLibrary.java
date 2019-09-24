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
        int[] x = new int[1024];
        int[] y = new int[1024];
        int[] z = new int[1024];
        for(int i = 0; i < 1024; i++){
            x[i] = i;
            y[i] = i;
        }
        for(int i = 0; i < 1024; i++){
            System.out.println("z[" + i + "] : " + z[i]);
        }
        obj.add_vec(x, y, z);
        for(int i = 0; i < 1024; i++){
            System.out.println("z[" + i + "] : " + z[i]);
        }
    }



}

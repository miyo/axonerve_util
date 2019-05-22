public class AxonerveKVS{
	
    private long ptr = 0;

    public native void clear();
    public native void remove(int [] k);
    public native void put(int[] k, int v);
    public native boolean get(int[] k, int[] v);

    public AxonerveKVS(){
        init();
    }

    private native void init();

    static {
        System.loadLibrary("axonerve_kvs_jni");
    }

}

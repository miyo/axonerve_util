public class AxonerveKVS{
	
    private long ptr = 0;

    private native void init(String bin);
	
    public native void clear();
    public native void remove(int [] k);
    public native void put(int[] k, int v);
    public native boolean get(int[] k, int[] v);
    public native void reset();

    public AxonerveKVS(String bin){
        init(bin);
    }


    static {
        System.loadLibrary("axonerve_kvs_jni");
    }

	public static void main(String... args){
		AxonerveKVS kvs = new AxonerveKVS(args[0]);
		kvs.put(new int[]{0xdeadbeef,0xdeadbeef,0xdeadbeef,0xdeadbeef}, 0xabadcafe);
		int[] v = new int[1];
		boolean f = kvs.get(new int[]{0xdeadbeef,0xdeadbeef,0xdeadbeef,0xdeadbeef}, v);
		System.out.printf("%b, %08x\n", f, v[0]);
		kvs.clear();
	}

}


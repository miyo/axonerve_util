package controllers;

import java.io.File;
import java.io.IOException;
import java.io.PrintStream;
import java.util.Hashtable;
import java.util.ArrayList;
import java.util.Comparator;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class WordCountLogic {

    private Hashtable<String, Integer> tbl;
    private ArrayList<String> uniqWords;
    private String textData;
    private String[] words;

    AxonerveWordcount hw;

    WordCountLogic(){
        init();
		System.out.println("load FPGA");
		String bin = "/home/centos/axonerve_util/wordcount/sdaccel/bin/binary_container_1.awsxclbin";
		hw = new AxonerveWordcount(bin);
		System.out.println("load FPGA...done");
    }

    public void init(){
        tbl = new Hashtable<>();
        uniqWords = new ArrayList<>();
        textData = "";
        words = new String[]{};
    }

    public void load(String srcFileName){
        try{
            setText(Files.readString(Path.of(srcFileName), Charset.forName("UTF-8")));
        }catch(IOException e){
            e.printStackTrace();
            System.exit(0);
        }
    }

    public void setText(String s){
        this.textData = s;
    }

    public void split(){
        words = textData.split("\\s+");
    }

    public void count(){
        for(String s: words){
            Integer v = tbl.get(s);
            if(v == null){
                tbl.put(s, 1);
                uniqWords.add(s);
            }else{
                tbl.put(s, v.intValue() + 1);
            }
        }
    }

	public void doWithFPGA(){
		byte[] w = new byte[words.length*16];
		for(int i = 0; i < words.length; i++){
			hw.packWords(words[i], i, w);
		}
		hw.clear();
		hw.doWordCount(w);
	}

    public void sort(){
        uniqWords.sort(new CountComparator(tbl));
    }

    public void dump(PrintStream out){
        int i = 0;
        for(String w: uniqWords){
            out.println(i + " " + w + " => " + tbl.get(w));
            i++;
        }
    }

    public WordCountResult[] getResult(){
        ArrayList<WordCountResult> lst = new ArrayList<>();
        for(String w: uniqWords){
            lst.add(new WordCountResult(w, tbl.get(w)));
        }
        return lst.toArray(new WordCountResult[0]);
    }

    class CountComparator implements Comparator<String>{
        private Hashtable<String, Integer> tbl;

        CountComparator(Hashtable<String, Integer> tbl){
            this.tbl = tbl;
        }

        public int compare(String l, String r) {
            Integer lv = tbl.get(l);
            Integer rv = tbl.get(r);
            if(lv == null) lv = Integer.MIN_VALUE;
            if(rv == null) rv = Integer.MIN_VALUE;
            if(lv > rv){
                return -1;
            }else if(lv < rv){
                return 1;
            }else{
                return 0;
            }
        }
    }

    public int getNumOfWords(){
        return words.length;
    }
    public int getNumOfUniqWords(){
        return uniqWords.size();
    }

    public static void main(String... args){
        WordCountLogic obj = new WordCountLogic();
        if(args.length == 0 || ((new File(args[0])).exists() == false)){
            System.out.println("usage: java WordcountJava textFileName");
            System.exit(0);
        }
        long t0 = System.currentTimeMillis();
        obj.load(args[0]);
        long t1 = System.currentTimeMillis();
        obj.split();
        long t2 = System.currentTimeMillis();
        obj.count();
        long t3 = System.currentTimeMillis();
        obj.sort();
        obj.dump(System.out);
        System.out.println("----");
        System.out.println("elapsed tiem for WordcountLogic.load(): "  + (t1-t0) + " ms.");
        System.out.println("elapsed tiem for WordcountLogic.split(): " + (t2-t1) + " ms.");
        System.out.println("elapsed tiem for WordcountLogic.count(): " + (t3-t2) + " ms.");
        System.out.println("#. of unique words: " + obj.getNumOfUniqWords());
        System.out.println("#. of words: " + obj.getNumOfWords());
        long bytes = (new File(args[0])).length();
        System.out.println("File size: " + bytes + " Bytes");
        System.out.printf("Throughput: %.3f Mwords/s, %.3f MB/s",
                (((double)obj.getNumOfWords())/((double)(t3-t0)))/1000.0,
                (((double)bytes)/((double)(t3-t0)))/1000.0);
        System.out.println();
    }

}

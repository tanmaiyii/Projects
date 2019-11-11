import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.commons.lang.StringUtils;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Mapper.Context;
import java.time.ZoneOffset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.*;
import java.lang.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.time.LocalDateTime;



public class PeakTimeMapper extends
		Mapper<Object, Text, Text, IntWritable> {

	private final IntWritable one = new IntWritable(1);
	private Text peakHour = new Text();

	public void map(Object key, Text value, Context context)
			throws IOException, InterruptedException {
		// Split by ;
		String[] line = value.toString().split(";");


	if (line.length == 4) {
		try{
        long time = Long.parseLong(line[0]);
      LocalDateTime time0 = LocalDateTime.ofEpochSecond(time/1000, 0, ZoneOffset.UTC);
			  int peakTime = time0.getHour();
				if (peakTime == 1) {
	//peakTime is hardcoded and pattern matching is used to find the hashtags
        Pattern p = Pattern.compile("(#\\w+)\\b");
				Matcher m = p.matcher(line[2].toLowerCase());
				while (m.find()) {
        peakHour.set(m.group());
      context.write(peakHour, one);

              }
        }
		}
		 catch(Exception e){
			 System.out.println("Error:" +e);
		 	}
	  }
  }
}

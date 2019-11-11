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
import java.time.LocalDateTime;
import java.util.*;

public class TweetTimeMapper extends
		Mapper<Object, Text, IntWritable, IntWritable> {

	private final IntWritable one = new IntWritable(1);
	private IntWritable hour = new IntWritable();

	public void map(Object key, Text value, Context context)
			throws IOException, InterruptedException {
      
       	String[] line = value.toString().split(";");
	// The tweet length is filtered to the format specified
	if (line.length == 4) {
		try{
		    //Tweets per hour are filtered by parsing the epochtime
        long time = Long.parseLong(line[0]);
      LocalDateTime time0 = LocalDateTime.ofEpochSecond(time/1000, 0, ZoneOffset.UTC);
        hour.set(time0.getHour());
      context.write(hour, one);
    }
		 catch(Exception e){
			 System.out.println("Error:" +e);
		 	}
	  }
  }
}

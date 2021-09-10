//const puppeteer = require('puppeteer');
import puppeteer from "puppeteer";
import fetch from "node-fetch";
import fs from "fs";
//import xml2srt from "yt-xml2srt";
import parser from "xml2json";

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  page.on('console', (msg) => console.log('PAGE LOG:', msg.text()));
  var myArgs = process.argv.slice(2);
  var stories=myArgs[0];
  // if(stories)
  // await page.goto('https://www.littlefox.com/en/readers/contents_list/DP000602');
  await page.goto(stories);
  await page.screenshot({ path: 'example.png' });
  //console.log(page)
  //z=null;
  const ar= await page.evaluate(async () => {
    //a=document.querySelectorAll("a.btn_play.btn-overlap");
    //a1=[...a].filter((e)=>{ return e.getAttribute("data-ga").indexOf("Journey to the West") > 0 });
    a=document.querySelectorAll("tr[data-fcid]");
    ax = [];
    ii=0;
    for (let i of a) {
      //console.log(i.getAttribute("href"))
      x=i.getAttribute("data-fcid");
      // x1=x.substr("javascript:Player.view(".length,x.length);
      // //console.log(x1);
      // x1=x1.substr(0,x1.indexOf(","));
      x1=x;
      x1=x1.replace(/\"/g,"");
      console.log(x1);
      //base64_encode("{\"fc_ids\":\"C0007022\",\"w\":1288,\"h\":810}")
      v="{\"fc_ids\":\""+x1+"\",\"w\":1288,\"h\":810}";
      console.log(v);
      console.log(base64_encode(v));
      ax[ii] = base64_encode(v);
      ii++;
    }
    // return a1;
    for (let i of a) {
      // console.log(i);
    }
    return  new Promise(resolve => { resolve(ax);
    });    
    });
  const vv = await ar;
  var dir = "subtitle/";
  if (!fs.existsSync(dir)){
  fs.mkdirSync(dir);
  }
  var listid = [];
  var l = 0;
  var map = {};
  var mapVideo = {};
  var mapSub = {};

  for (let i of vv) {
    // console.log(i);

    const t = await fetch("https://www.littlefox.com/en/player_h5/view", {
    "headers": {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "cache-control": "no-cache",
      "pragma": "no-cache",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "cookie": "PHPSESSID=uj7bl0at8jkm5llhpkoo508ik6; h5play_info="+i+"; _ga=GA1.2.2097850282.1631243843; _gid=GA1.2.1499091484.1631243843; _gat=1"
    },
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });
  // // console.log(await t.text());

  var z = await t.text();
  // url = z.substr(z.indexOf("\"video_url\":")+"\"video_url\":".length, z.indexOf(",\"purge_val\""));
  // console.log(z);
  // await getInfo(z);
  var url = getVal(z,"\"video_url\":",",\"purge_val\"");
  var id = getVal(z,"\"fc_id\":",",\"cont_step_no\"");
  var mod = getVal(z,"\"mod_date\":","}];\n");
  var name = getVal(z,"\"cont_name\":\"","\",\"cont_sub_name\":\"");
  var titleTime = getVal(z,"\"title_time\":","\",\"video_url\"");
  var nextId = getVal(z,"\"next_fc_id\":",",\"ebook\"");
  console.log(url.toString().replace(/\\/g,""));
  console.log(id);
  console.log(mod);
  url=url.toString().replace(/\\/g,"");
  url=url.toString().replace(/\"/g,"");
  id=id.toString().replace(/\"/g,"");
  mod=mod.toString().replace(/\"/g,"");
  name=name.replace(/\"/g,"");
  titleTime=titleTime.replace(/\"/g,"");
  nextId=nextId.replace(/\"/g,"");
  var ids=[]
  ids[0] = id;
  ids[1] = nextId;
  listid[l] = ids;
  l++;
  map[nextId] = id;
  console.log(url.toString().replace(/\\/g,""));
  console.log(id);
  console.log(mod);
  console.log(name);
  console.log(titleTime);
  // console.log(map);
  var subtitleurl="https://cdn.littlefox.co.kr/contents/caption/"+id+".xml?v="+mod
  var videourl="https://cdn.littlefox.com" + url;
  console.log(subtitleurl);
  console.log(videourl);
  var videoFileName = "\""+id+"_"+name+".mp4\"";
  mapVideo[id] = videoFileName;
  var ffmeg = "ffmpeg -f hls -referer 'https://www.littlefox.com/en' -user_agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/82.0.4050.0 Safari/537.36' -f hls -i \""+videourl+"\" -c copy "+videoFileName;
  console.log(ffmeg);
  
  fs.appendFile('ffmpeg.cmd', ffmeg+"\n", err => {
    if (err) {
      console.log(err)
      return
    }
    //done!
  });
  
  var sub= await fetch(subtitleurl);
  var content = await sub.text();
  // console.log(content);
  var dir = "subtitle/";
  if (!fs.existsSync(dir)){
  fs.mkdirSync(dir);
  }
  const data = fs.writeFileSync(dir+id+"_"+name+".xml", content);

  var json = JSON.parse(parser.toJson(content, {reversible: true}));
  var e = json["Subtitle"]["Paragraph"];

  var sub = "";
  for(let x of e){
    //console.log(x);
    //console.log(inputToSRT(x));
    sub += inputToSRT(x, titleTime*1000);
  }
  var videoSubName= dir+id+"_"+name+".srt";
  fs.writeFileSync(videoSubName, sub);
  mapSub[id] = videoSubName;
  

  }
  

 const t = await fetch("https://www.littlefox.com/en/player_h5/view", {
    "headers": {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "cache-control": "no-cache",
      "pragma": "no-cache",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "cookie": "PHPSESSID=uj7bl0at8jkm5llhpkoo508ik6; h5play_info=eyJmY19pZHMiOiJDMDAwNzAyMiIsInciOjEyODgsImgiOjgxMH0=; _ga=GA1.2.2097850282.1631243843; _gid=GA1.2.1499091484.1631243843; _gat=1"
    },
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });
  // console.log(await t.text());
  
  // var z = await t.text();
  // // url = z.substr(z.indexOf("\"video_url\":")+"\"video_url\":".length, z.indexOf(",\"purge_val\""));
  // console.log(z);
  // // await getInfo(z);
  // var url = getVal(z,"\"video_url\":",",\"purge_val\"");
  // var id = getVal(z,"\"fc_id\":",",\"cont_step_no\"");
  // var mod = getVal(z,"\"mod_date\":","}];\n");
  // var name = getVal(z,"\"cont_name\":\"","\",\"cont_sub_name\":\"");
  // var titleTime = getVal(z,"\"title_time\":","\",\"video_url\"");
  // var nextId = getVal(z,"\"next_fc_id\":",",\"ebook\"");
  // console.log(url.toString().replace(/\\/g,""));
  // console.log(id);
  // console.log(mod);
  // url=url.toString().replace(/\\/g,"");
  // url=url.toString().replace(/\"/g,"");
  // id=id.toString().replace(/\"/g,"");
  // mod=mod.toString().replace(/\"/g,"");
  // name=name.replace(/\"/g,"");
  // titleTime=titleTime.replace(/\"/g,"");
  // nextId=nextId.replace(/\"/g,"");
  // var ids=[]
  // ids[0] = id;
  // ids[1] = nextId;
  // listid[l] = ids;
  // l++;
  // map[nextId] = id;
  // console.log(url.toString().replace(/\\/g,""));
  // console.log(id);
  // console.log(mod);
  // console.log(name);
  // console.log(titleTime);
  // console.log(map);
  // var subtitleurl="https://cdn.littlefox.co.kr/contents/caption/"+id+".xml?v="+mod
  // var videourl="https://cdn.littlefox.com" + url;
  // console.log(subtitleurl);
  // console.log(videourl);
  // var ffmeg = "ffmpeg -f hls -referer 'https://www.littlefox.com/en' -user_agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/82.0.4050.0 Safari/537.36' -f hls -i \""+videourl+"\" -c copy \""+id+"_"+name+".mp4\"";
  // console.log(ffmeg);
  
  // fs.appendFile('ffmpeg.cmd', ffmeg+"\n", err => {
  //   if (err) {
  //     console.log(err)
  //     return
  //   }
  //   //done!
  // });
  
  // var sub= await fetch(subtitleurl);
  // var content = await sub.text();
  // // console.log(content);
  // var dir = "subtitle/";
  // if (!fs.existsSync(dir)){
  // fs.mkdirSync(dir);
  // }
  // const data = fs.writeFileSync(dir+id+"_"+name+".xml", content);

  // var json = JSON.parse(parser.toJson(content, {reversible: true}));
  // var e = json["Subtitle"]["Paragraph"];

  // var sub = "";
  // for(let x of e){
  //   //console.log(x);
  //   //console.log(inputToSRT(x));
  //   sub += inputToSRT(x, titleTime*1000);
  // }
  // fs.writeFileSync(dir+id+"_"+name+".srt", sub);
  
  console.log(map);
  var key = '';
  var z = null;
  z =map[key];
  if(z == null) key = null;
  var ll = [];
  var i=0;
  while((z =map[key]) != null){
    key = z;
    ll[i++] = key;
  }
  // console.log(ll);
  i = ll.length;
  var summary = "";
  for(i = ll.length-1; i >= 0; i--){
    var e = ll[i] + " " + mapVideo[ll[i]] + " \"" +  mapSub[ll[i]]+"\"";
    console.log(e);
    summary += e+"\n";

  }

  fs.appendFile('summary.txt', summary, err => {if (err) {console.log(err) ;return}
    //done!
  });

  await browser.close();
})();

function getVal(x,t1,t2) {
  var val = x.substr(x.indexOf(t1)+t1.length, x.indexOf(t2) - x.indexOf(t1)-t1.length);
  return val;
}



function srtTimestamp(milliseconds) {
  var $milliseconds = milliseconds;  
  var $seconds = Math.floor($milliseconds / 1000);
  var $minutes = Math.floor($seconds / 60);
  var $hours = Math.floor($minutes / 60);
  var $milliseconds = $milliseconds % 1000;
  var $seconds = $seconds % 60;
  var $minutes = $minutes % 60;
  return ($hours < 10 ? '0' : '') + $hours + ':'
       + ($minutes < 10 ? '0' : '') + $minutes + ':'
       + ($seconds < 10 ? '0' : '') + $seconds + ','
       + ($milliseconds < 100 ? '0' : '') + ($milliseconds < 10 ? '0' : '') + $milliseconds;
}

function inputToSRT(sub_in, delay ) {
  var text = sub_in.Text.$t;
  text=text.replace(/\[@/g,"<font color=\"#ffff54\">");
  text=text.replace(/@]/g,"</font>");

return sub_in.Number.$t + "\r\n" + srtTimestamp(sub_in.StartMilliseconds.$t + delay) + " --> " + srtTimestamp(sub_in.EndMilliseconds.$t + delay) + "\r\n" + text + "\r\n\r\n";
}

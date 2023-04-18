export function Config() {
}

Config.filter = function () {
    let conf = {}
    //[3, 7, 10, 15, 20, 30, 50, 100, 200, 365, 500, 1000, 5000];
    conf["days"] = [1, 3, 7, 10, 30, 100, 150, 1000];
    conf["bombday"] = 30;
    conf["shortPeriods"] = [5, 10, 20, 25, 26, 30, 50, 100, 200];
    conf["shortSidewayDays"] = 30;
    conf["numSidewayDays"] = 300;
    return conf;
}

Config.muaban = function () {
    let conf = {}
    conf["OutlierThreshold"] = 10;
    conf["StdThreshold"] = 1.6;
    conf["enableWriteXlsxSymbol"] = true;
    conf["uppct"] = 4;
    conf["downpct"] = -5;
    conf["session"] = 3;
    //yyyy,month,day monthn 0-11 day 1-31
    conf["sessionFromDate"] = new Date(2023, 3, 1);
    
    conf["sumField"] = ['val_bu', 'val_sd', 'val_uk', 'sd', 'bu', 'uk','val','sum_vol','bu-sd_val','bu-sd']
    return conf;
}


Config.muabanSum = function () {
    let conf = {}
    conf["sumFromDate"] = new Date(2023, 3, 18); 
    conf["sumField"] = ['val_bu', 'val_sd', 'val_uk', 'sd', 'bu', 'uk','val','sum_vol','bu-sd_val','bu-sd']   
    return conf;
}
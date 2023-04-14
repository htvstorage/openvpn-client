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
    conf["OutlierThreshold"] = 2;
    return conf;
}
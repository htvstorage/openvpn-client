let ds = new Date(2022, 1, 1)
let data = []
let now = new Date();
while (ds < now) {
   
    let start = (ds.getDate() < 10 ? "0" + ds.getDate() : ds.getDate() )+ "/" + ( (ds.getMonth() + 1) < 10 ? "0" + (ds.getMonth() + 1) : (ds.getMonth() + 1) )+ "/" + ds.getFullYear();    
    let de = new Date(ds.setDate(ds.getDate() + 180));
    if (de >= now) de = new Date(now.setDate(now.getDate() - 1))
    let end = (de.getDate() < 10 ? "0" + de.getDate() : de.getDate() )+ "/" + ( (de.getMonth() + 1) < 10 ? "0" + (de.getMonth() + 1) : (de.getMonth() + 1) )+ "/" + de.getFullYear();    
    ds = new Date(de.setDate(de.getDate() + 1));
    console.log(ds,start,end) 
    let a = await fetch("https://smartone.vps.com.vn/Api/Proxy", {
        "headers": {
            "accept": "application/json, text/javascript, */*; q=0.01",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "content-type": "application/json; charset=UTF-8",
            "sec-ch-ua": "\"Not/A)Brand\";v=\"99\", \"Google Chrome\";v=\"115\", \"Chromium\";v=\"115\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Windows\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            "x-requested-with": "XMLHttpRequest",
            "cookie": "_fbp=fb.2.1669623965921.1893403188; _ga_M9VTXEHK9C=GS1.1.1669958644.2.0.1669958644.0.0.0; listStockSelected=AAA%2C; _ga_QW53DJZL1X=GS1.1.1687863998.16.0.1687863998.0.0.0; _ga=GA1.1.1812813168.1668398014; _ga_EES4F3SJT8=GS1.1.1687922549.1.1.1687923957.0.0.0; _ga_790K9595DC=GS1.1.1690540708.50.0.1690540708.0.0.0; listStockId=012c4721e30f413c9050152f515b8e81; listStockName=OK; ASP.NET_SessionId=0bxz4xwdmpz3zhqkirga24sg; __RequestVerificationToken=ZUn3qVUQhdoUzjg0pJn7OKmiuBS3NrXBka5MZ0KT6smOVEM-FMdOQWjNpkhXF71EGaJ1wNeqAkyTNGssUZ6oQNl-_So1; DefaultAccount=4986391; startPs=06-07-2020; endPs=05-07-2020; listStock=DIG%2CPDR%2CNVL%2CNKG%2CHSG%2CKBC%2CSZC%2CVCI%2CVKC%2CHPG%2CDXG%2CCEO%2CL14; _ga_4WDBKERLGC=GS1.1.1692953885.140.0.1692953885.0.0.0",
            "Referer": "https://smartone.vps.com.vn/?popupSmsOtp=0",
            "Referrer-Policy": "strict-origin-when-cross-origin"
        },
        "body": "{\"group\":\"B\",\"user\":\"498639\",\"session\":\"ed9a3218-c59f-433f-9361-78b5da7c13c6\",\"data\":{\"type\":\"cursor\",\"cmd\":\"PPL_GetAll\",\"p1\":\"4986391\",\"p2\":\"\",\"p3\":\""+start+"\",\"p4\":\""+end+"\",\"p5\":\"1\",\"p6\":\"3000\"}}",
        "method": "POST"
    });

    let z = await a.json()
    console.table(z.data)
    data.push(...z.data)
    
}



let profit = data.map(e => e.C_PROFIT_LOSS).reduce((a, b) => { return a + b }, 0)

data.map(e => { return { code: e.C_SHARE_CODE, val: e.C_PROFIT_LOSS } })

let x1 = data.map(e => { return { code: e.C_SHARE_CODE, val: e.C_PROFIT_LOSS } })
let sum = {}
x1.forEach(e => {
    if (sum[e.code] == undefined) sum[e.code] = 0;
    sum[e.code] += e.val;
});

let pa = []
Object.keys(sum).forEach(k => {
    pa.push({ code: k, val: sum[k] })
})
pa.sort((a, b) => { return a.val - b.val })

console.table(pa)
console.table([profit])

const eq = (o, p, v) => {
    return o[p] === v
}
const gt = (o, p, v) => {
    return o[p] > v
}
const ge = (o, p, v) => {
    // console.log(o[p])
    return o[p] >= v
}
const lt = (o, p, v) => {
    return o[p] < v
}
const le = (o, p, v) => {
    return o[p] <= v
}

const ct = (o, p, ...args) => {
    return args.includes(o[p])
}

const bw = (o, p, v1, v2) => {
    return o[p] >= v1 && o[p] <= v2
}

const dbw = (o, p, v1, v2) => {
    if(!moment(v2, 'YYYY-MM-DD').isValid()){
        console.log("Not vaild ",v2)
    }
    if(!moment(v1, 'YYYY-MM-DD').isValid()){
        console.log("Not vaild ",v1)
    }
    return o[p] >= +moment(v1, 'YYYY-MM-DD').format("X")  && o[p] <= +moment(v2, 'YYYY-MM-DD').format("X")
}
const and = (...args) => {
    let ret = true;
    args.forEach(e => {
        ret = ret && e;
    })
    return ret
}

const filter = (data, script) => {
    const evalScript = script.replaceAll('(', '(o,')
    // console.log(evalScript)
    return data.filter(o => {
        // console.log(eval(evalScript))
        return eval(evalScript)
    })
}
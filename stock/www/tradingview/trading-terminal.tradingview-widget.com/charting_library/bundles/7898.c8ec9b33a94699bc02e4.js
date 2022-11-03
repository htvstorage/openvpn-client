"use strict";
(self.webpackChunktradingview = self.webpackChunktradingview || []).push([
    [7898], {
        44e3: (t, e, s) => {
            s.d(e, {
                changeDescription: () => f,
                create: () => b,
                exact: () => m,
                exclude: () => S,
                getListById: () => I,
                getListIds: () => L,
                getListsMap: () => g,
                insert: () => u,
                put: () => h,
                reducer: () => T,
                remove: () => y,
                rename: () => p,
                replace: () => d,
                setup: () => c
            });
            var o = s(93921);

            function n(t, e) {
                if (t.length !== e.length) return !1;
                for (let s = 0; s < t.length; ++s)
                    if (t[s] !== e[s]) return !1;
                return !0
            }
            const r = Symbol();
            const i = {
                lists: {
                    ids: [],
                    byId: {}
                },
                timestamp: null
            };

            function l(t, e) {
                t.lists.ids.push(e.id), t.lists.byId[e.id] = {
                    id: e.id,
                    name: e.name,
                    description: e.description,
                    symbols: [...e.symbols],
                    shared: e.shared
                }
            }
            const a = (0, o.createSlice)({
                    name: "custom-lists",
                    initialState: i,
                    reducers: {
                        setup: (t, e) => {
                            const {
                                lists: s,
                                timestamp: o
                            } = e.payload, n = {
                                lists: {
                                    ids: [],
                                    byId: {}
                                },
                                timestamp: null
                            };
                            for (const t of s) l(n, t);
                            return n.timestamp = o, n
                        },
                        insert: (t, e) => {
                            const {
                                id: s,
                                symbols: o,
                                before: i
                            } = e.payload, {
                                lists: l
                            } = t, a = l.byId[s];
                            if (void 0 === a) return;
                            const c = new Set(o);
                            let u;
                            if (void 0 !== i && c.has(i)) {
                                u = r;
                                for (let t = a.symbols.indexOf(i); t >= 0; --t)
                                    if (!c.has(a.symbols[t])) {
                                        u = a.symbols[t];
                                        break
                                    }
                            }
                            const d = a.symbols.filter(t => !c.has(t)),
                                m = function(t, e, s) {
                                    const o = void 0 === s ? void 0 !== e ? t.indexOf(e) : void 0 : s === r ? 0 : t.indexOf(s) + 1;
                                    return -1 !== o ? o : void 0
                                }(d, i, u);
                            void 0 === m ? d.push(...c) : d.splice(m, 0, ...c), n(d, a.symbols) || (a.symbols = d)
                        },
                        replace: (t, e) => {
                            const {
                                id: s,
                                current: o,
                                next: n
                            } = e.payload, {
                                lists: r
                            } = t, i = r.byId[s];
                            if (void 0 === i) return;
                            if (o === n) return;
                            let l = !1,
                                a = !1;
                            const c = [];
                            for (const t of i.symbols) {
                                if (t === n) {
                                    a = !0;
                                    break
                                }
                                t === o ? (c.push(n), l = !0) : c.push(t)
                            }
                            l && !a && (i.symbols = c)
                        },
                        exact: (t, e) => {
                            const {
                                id: s,
                                symbols: o
                            } = e.payload, {
                                lists: r
                            } = t, i = r.byId[s];
                            if (void 0 === i) return;
                            const l = [...new Set(o)];
                            n(l, i.symbols) || (i.symbols = l)
                        },
                        exclude: (t, e) => {
                            const {
                                id: s,
                                symbols: o
                            } = e.payload, {
                                lists: r
                            } = t, i = r.byId[s];
                            if (void 0 === i) return;
                            const l = new Set(o),
                                a = i.symbols.filter(t => !l.has(t));
                            n(a, i.symbols) || (i.symbols = a)
                        },
                        remove: (t, e) => {
                            const {
                                id: s
                            } = e.payload, {
                                lists: o
                            } = t;
                            if (void 0 === o.byId[s]) return;
                            const n = o.ids.filter(t => t !== s);
                            o.ids = n, delete o.byId[s]
                        },
                        create: (t, e) => {
                            const {
                                id: s,
                                name: o,
                                symbols: n
                            } = e.payload, {
                                lists: r
                            } = t;
                            void 0 === r.byId[s] && l(t, {
                                id: s,
                                name: o,
                                symbols: n,
                                shared: !1,
                                description: null
                            })
                        },
                        put: (t, e) => {
                            const {
                                id: s,
                                name: o,
                                description: n,
                                symbols: r,
                                shared: i
                            } = e.payload, {
                                lists: a
                            } = t;
                            void 0 === a.byId[s] ? l(t, {
                                id: s,
                                name: o,
                                description: n,
                                symbols: r,
                                shared: i
                            }) : a.byId[s] = {
                                id: s,
                                name: o,
                                description: n,
                                shared: i,
                                symbols: [...r]
                            }
                        },
                        rename: (t, e) => {
                            const {
                                id: s,
                                name: o
                            } = e.payload, {
                                lists: n
                            } = t, r = n.byId[s];
                            void 0 !== r && r.name !== o && (r.name = o)
                        },
                        changeDescription: (t, e) => {
                            const {
                                id: s,
                                description: o
                            } = e.payload, {
                                lists: n
                            } = t, r = n.byId[s];
                            void 0 !== r && r.description !== o && (r.description = o)
                        },
                        share: (t, e) => {
                            const {
                                id: s,
                                shared: o
                            } = e.payload, {
                                lists: n
                            } = t, r = n.byId[s];
                            void 0 !== r && r.shared !== o && (r.shared = o)
                        }
                    }
                }),
                {
                    setup: c,
                    insert: u,
                    replace: d,
                    exact: m,
                    exclude: S,
                    remove: y,
                    create: b,
                    put: h,
                    rename: p,
                    changeDescription: f,
                    share: _
                } = a.actions,
                {
                    reducer: T
                } = a;

            function g(t) {
                return t.lists.byId
            }

            function I(t, e) {
                var s;
                return null !== (s = g(t)[e]) && void 0 !== s ? s : null
            }

            function L(t) {
                return t.lists.ids
            }
        },
        73850: (t, e, s) => {
            s.d(e, {
                SEPARATOR_PREFIX: () => o
            });
            const o = "###"
        },
        47152: (t, e, s) => {
            function o(t) {
                let e = null;
                return (s, ...o) => (null == e || e.abort(), e = new AbortController, null == s || s.addEventListener("error", () => null == e ? void 0 : e.abort(), {
                    once: !0
                }), t(e.signal, ...o))
            }

            function n(t) {
                if (!a(t)) throw t
            }

            function r(t) {
                if (a(t)) throw t
            }

            function i(t) {
                return (null == t ? void 0 : t.aborted) ? Promise.reject(l()) : new Promise((e, s) => {
                    null == t || t.addEventListener("abort", () => s(l()), {
                        once: !0
                    })
                })
            }

            function l() {
                return new DOMException("Aborted", "AbortError")
            }

            function a(t) {
                return t instanceof Error && "AbortError" === t.name
            }

            function c(t, e) {
                return Promise.race([i(t), e])
            }
            async function u(t, e) {
                let s;
                try {
                    await c(t, new Promise(t => {
                        s = setTimeout(t, e)
                    }))
                } finally {
                    clearTimeout(s)
                }
            }
            s.d(e, {
                respectLatest: () => o,
                skipAbortError: () => n,
                rethrowAbortError: () => r,
                isAbortError: () => a,
                respectAbort: () => c,
                delay: () => u
            })
        },
        37914: (t, e, s) => {
            s.d(e, {
                quoteSessionAdapters: () => a
            });
            var o = s(88537),
                n = s(21162),
                r = s(98171);
            const i = new Map;
            class l {
                constructor(t, e, s = "watchlist") {
                    this._symbolDataHandlers = new Map, this._fastSymbols = new Set, this._subscribedSymbols = new Set, this._subscriptionSet = new Set, this._cancelSubscriptionSet = new Set, this._resolvedSymbolsSet = new Set, this._quoteSessionDataHandler = t => {
                        const e = (0, o.ensureDefined)(t.symbolname),
                            {
                                filtered: s,
                                keepSubscription: n
                            } = this._applyDataFilters(t);
                        n || this._unsubscribeSymbols([e]), this._setSymbolDataCache(e, s);
                        const r = this._symbolDataHandlers.get(e);
                        r && r(s)
                    }, this._clientId = t, this._quoteSession = (0, n.getQuoteSessionInstance)(s), this._lastSymbolData = e || new Map
                }
                destroy() {
                    const t = Array.from(this._subscribedSymbols);
                    this._unsubscribeSymbols(t)
                }
                addFastSymbol(t) {
                    this._fastSymbols.has(t) || !this._subscribedSymbols.has(t) || (0, r.isSeparatorItem)(t) || (this._fastSymbols.add(t), this._quoteSession.setFastSymbols(this._clientId, Array.from(this._fastSymbols)))
                }
                removeFastSymbol(t) {
                    this._fastSymbols.has(t) && (this._fastSymbols.delete(t), this._quoteSession.setFastSymbols(this._clientId, Array.from(this._fastSymbols)))
                }
                addSymbolDataHandler(t, e) {
                    (0, r.isSeparatorItem)(t) || this._symbolDataHandlers.set(t, e)
                }
                removeSymbolDataHandler(t) {
                    this._symbolDataHandlers.delete(t)
                }
                addToSubscriptionSet(t) {
                    t.forEach(t => {
                        (0, r.isSeparatorItem)(t) || this._subscriptionSet.add(t)
                    })
                }
                clearSubscriptionSet() {
                    this._subscriptionSet.clear()
                }
                addToCancelSubscriptionSet(t) {
                    t.forEach(t => {
                        (0, r.isSeparatorItem)(t) || this._cancelSubscriptionSet.add(t)
                    })
                }
                commitSubscriptionChanges() {
                    Array.from(this._subscriptionSet).forEach(t => {
                        this._cancelSubscriptionSet.has(t) && (this._subscriptionSet.delete(t), this._cancelSubscriptionSet.delete(t))
                    }), this._subscribeSymbols(Array.from(this._subscriptionSet)), this._subscriptionSet.clear(), this._unsubscribeSymbols(Array.from(this._cancelSubscriptionSet)), this._cancelSubscriptionSet.clear(), this._quoteSession.setFastSymbols(this._clientId, Array.from(this._fastSymbols))
                }
                getLastSymbolData(t) {
                    return this._lastSymbolData.get(t)
                }
                getSymbolSnapshotForAll(t, e, s = guid()) {
                    const o = t.map(t => this.getSymbolSnapshot(t, e, s));
                    return Promise.all(o)
                }
                getSymbolSnapshot(t, e, s = guid()) {
                    if ((0, r.isSeparatorItem)(t)) return Promise.resolve(void 0);
                    const o = this._lastSymbolData.get(t);
                    if (o && "ok" === o.status) {
                        const s = this._resolvedSymbolsSet.has(t) && o.complete;
                        if (c(o, e) || s) return this._resolvedSymbolsSet.add(t), Promise.resolve(o)
                    }
                    return new Promise(o => {
                        const n = this._clientId + "_snapshot_" + s,
                            r = s => {
                                const {
                                    filtered: i,
                                    keepSubscription: l
                                } = this._applyDataFilters(s);
                                i && "error" !== i.status && this._setSymbolDataCache(t, i), (!l || c(i, e) || "error" === i.status || i.complete) && (this._quoteSession.unsubscribe(n, t, r), o(i))
                            };
                        this._quoteSession.subscribe(n, t, r)
                    })
                }
                getSymbolFullName(t) {
                    if ((0, r.isSeparatorItem)(t)) return Promise.resolve(t);
                    if (i.has(t)) return (0, o.ensureDefined)(i.get(t));
                    const e = new Promise(e => {
                        const s = this._clientId + "_SymbolFullName",
                            o = n => {
                                const r = n => {
                                    this._quoteSession.unsubscribe(s, t, o), e(n)
                                };
                                n && "ok" === n.status ? n.values && r(n.values.pro_name || t) : r(t)
                            };
                        this._quoteSession.subscribe(s, t, o)
                    });
                    return i.set(t, e), e
                }
                getSymbolsFullNames(t) {
                    return Promise.all(t.map(t => this.getSymbolFullName(t)))
                }
                getUniqueSymbolsFullNames(t) {
                    return this.getSymbolsFullNames(t).then(t => Array.from(new Set(t)))
                }
                _subscribeSymbols(t) {
                    this._quoteSession.subscribe(this._clientId, t, this._quoteSessionDataHandler), t.forEach(t => this._subscribedSymbols.add(t))
                }
                _unsubscribeSymbols(t) {
                    this._quoteSession.unsubscribe(this._clientId, t, this._quoteSessionDataHandler), t.forEach(t => {
                        this._subscribedSymbols.delete(t)
                    })
                }
                _setSymbolDataCache(t, e) {
                    var s;
                    const o = (null === (s = this._lastSymbolData.get(t)) || void 0 === s ? void 0 : s.values) || {};
                    this._resolvedSymbolsSet.add(t), this._lastSymbolData.set(t, { ...e,
                        values: { ...o,
                            ...e.values
                        }
                    })
                }
                _applyDataFilters(t) {
                    return {
                        filtered: t,
                        keepSubscription: !0
                    }
                }
            }
            const a = new class {
                constructor() {
                    this._adaptersMap = new Map, this._lastSymbolData = new Map
                }
                destroy() {
                    this._adaptersMap.forEach(t => {
                        t.forEach(t => t.destroy())
                    }), this._lastSymbolData.clear()
                }
                get(t, e = "watchlist") {
                    let s;
                    const o = this._adaptersMap.get(t);
                    if (o) {
                        const n = o.get(e);
                        n ? s = n : (s = new l(t, this._lastSymbolData, e), o.set(e, s))
                    } else {
                        s = new l(t, this._lastSymbolData, e);
                        const o = new Map;
                        o.set(e, s), this._adaptersMap.set(t, o)
                    }
                    return s
                }
            };

            function c(t, e) {
                for (const s of Array.from(e))
                    if (!t.values.hasOwnProperty(s)) return !1;
                return !0
            }
        },
        19769: (t, e, s) => {
            s.r(e), s.d(e, {
                selectNextAvailableSymbol: () => n,
                showContextMenu: () => r,
                initWidget: () => i,
                updateWidget: () => l,
                updateWidgetOptions: () => a,
                selectAllSymbols: () => c,
                addOrUpdateSymbolList: () => u,
                removeSymbolList: () => d,
                setSymbolLists: () => m,
                selectHotlist: () => S,
                updatePosition: () => y,
                updateBulkPositions: () => b,
                updateActiveList: () => h
            });
            var o = s(70644);
            const n = (t, e, s, n) => ({
                    type: o.SELECT_NEXT_AVAILABLE_SYMBOL,
                    widgetId: t,
                    currentSymbol: e,
                    keyboardAction: s,
                    cancelSetOnChart: n
                }),
                r = (t, e, s, n) => ({
                    type: o.SHOW_CONTEXT_MENU,
                    symbol: e,
                    position: p(s),
                    widgetId: t,
                    size: n
                }),
                i = (t, e, s, n) => ({
                    type: o.INIT_WIDGET,
                    options: n,
                    id: t,
                    columns: s,
                    tickerType: e
                }),
                l = (t, e) => ({
                    type: o.UPDATE_WIDGET,
                    widgetId: t,
                    widget: e
                }),
                a = (t, e) => ({
                    type: o.UPDATE_WIDGET_OPTIONS,
                    widgetId: t,
                    options: e
                }),
                c = t => ({
                    type: o.SELECT_ALL_SYMBOLS,
                    widgetId: t
                }),
                u = t => ({
                    type: o.ADD_OR_UPDATE_SYMBOL_LIST,
                    symbolList: t
                }),
                d = t => ({
                    type: o.REMOVE_SYMBOL_LIST,
                    id: t
                }),
                m = t => ({
                    type: o.SET_SYMBOL_LISTS,
                    symbolLists: t
                }),
                S = (t, e, s) => ({
                    type: o.SELECT_HOTLIST,
                    widgetId: t,
                    exchange: e,
                    group: s
                }),
                y = (t, e) => ({
                    type: o.UPDATE_POSITIONS,
                    symbol: t,
                    position: e
                }),
                b = t => ({
                    type: o.UPDATE_BULK_POSITIONS,
                    map: t
                }),
                h = t => ({
                    type: o.UPDATE_ACTIVE_LIST,
                    id: t
                });

            function p(t) {
                var e;
                const s = null === (e = t.touches) || void 0 === e ? void 0 : e.map(t => ({
                    clientX: t.clientX,
                    clientY: t.clientY
                }));
                return {
                    clientX: t.clientX,
                    clientY: t.clientY,
                    touches: s,
                    attachToXBy: t.attachToXBy,
                    attachToYBy: t.attachToYBy,
                    boxHeight: t.boxHeight
                }
            }
        },
        70644: (t, e, s) => {
            s.d(e, {
                SELECT_NEXT_AVAILABLE_SYMBOL: () => n,
                UPDATE_POSITIONS: () => r,
                UPDATE_BULK_POSITIONS: () => i,
                INIT_WIDGET: () => l,
                SHOW_CONTEXT_MENU: () => a,
                UPDATE_WIDGET: () => c,
                UPDATE_WIDGET_OPTIONS: () => u,
                SELECT_ALL_SYMBOLS: () => d,
                ADD_OR_UPDATE_SYMBOL_LIST: () => m,
                SET_SYMBOL_LISTS: () => S,
                REMOVE_SYMBOL_LIST: () => y,
                SELECT_HOTLIST: () => b,
                UPDATE_ACTIVE_LIST: () => h
            });
            const o = (0, s(15078).createActionTypeFactory)("WATCHLISTS"),
                n = o("SELECT_NEXT_AVAILABLE_SYMBOL"),
                r = o("UPDATE_POSITIONS"),
                i = o("UPDATE_BULK_POSITIONS"),
                l = o("INIT_WIDGET"),
                a = o("SHOW_CONTEXT_MENU"),
                c = o("UPDATE_WIDGET"),
                u = o("UPDATE_WIDGET_OPTIONS"),
                d = o("SELECT_ALL_SYMBOLS"),
                m = o("ADD_OR_UPDATE_SYMBOL_LIST"),
                S = o("SET_SYMBOL_LISTS"),
                y = o("REMOVE_SYMBOL_LIST"),
                b = o("SELECT_HOTLIST"),
                h = o("UPDATE_ACTIVE_LIST")
        },
        63940: (t, e, s) => {
            s.r(e), s.d(e, {
                addWatchlistSymbolsThunk: () => E,
                createWatchlistThunk: () => T,
                getActiveWatchlistThunk: () => C,
                getCustomWatchlistsThunk: () => g,
                putCustomWatchlistsThunk: () => I,
                removeWatchlistSymbolsThunk: () => A,
                removeWatchlistThunk: () => D,
                renameWatchlistThunk: () => L,
                replaceWatchlistSymbolsThunk: () => v,
                setActiveWatchlistThunk: () => w,
                symbolListRepositorySaga: () => p,
                validateWatchListSymbols: () => f
            });
            var o = s(36349),
                n = s(44e3),
                r = s(25177),
                i = s(33290),
                l = s(31148),
                a = s(19769),
                c = s(51951),
                u = s(53055),
                d = s(47152),
                m = s(1373),
                S = s(79359),
                y = s(97169);

            function* b() {
                for (yield(0, o.put)((0, y.asAction)(C(null)));;) {
                    yield(0, o.take)([n.remove, n.setup]);
                    const t = yield(0, o.select)();
                    null === (0, m.getCurrentViewableListByWidgetId)(t, S.WATCHLIST_WIDGET_ID) && (yield(0, o.put)((0, y.asAction)(C(null))))
                }
            }
            const h = (0, c.getLogger)("Platform.Model.SymbolLists");

            function* p() {
                yield(0, o.fork)(b)
            }

            function f(t) {
                return new Promise(e => {
                    quoteSessionAdapters.get(WATCHLIST_WIDGET_ID).getUniqueSymbolsFullNames(t).then(t => {
                        e(t)
                    })
                })
            }

            function _(t, e, s) {
                (0, u.showWarning)({
                    title: e || (0, r.t)("Watchlist error"),
                    text: t
                }, s)
            }

            function T(t) {
                const e = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (s, o) => {
                    try {
                        const o = await e.createWatchList(t);
                        return null === o ? null : (s((0, n.create)({
                            id: o.id,
                            name: o.name,
                            symbols: o.symbols
                        })), o.id)
                    } catch (t) {
                        return _(t.message), null
                    }
                }
            }
            const g = (0, d.respectLatest)((function(t) {
                const e = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (s, o) => {
                    try {
                        const o = await (0, d.respectAbort)(t, e.getCustomWatchLists());
                        s((0, n.setup)({
                            lists: o.map(t => ({
                                id: t.id,
                                name: t.name,
                                description: t.description,
                                symbols: t.symbols,
                                shared: t.shared
                            })),
                            timestamp: Date.now()
                        }))
                    } catch (t) {
                        (0, d.skipAbortError)(t)
                    }
                }
            }));

            function I(t, e) {
                const s = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (o, r) => {
                    try {
                        const r = await (0, d.respectAbort)(t, s.putWatchList(e));
                        o((0, n.put)({
                            id: r.id,
                            name: r.name,
                            description: r.description,
                            symbols: r.symbols,
                            shared: r.shared
                        }))
                    } catch (t) {
                        (0, d.rethrowAbortError)(t), _(t.message)
                    }
                }
            }

            function L(t, e, s) {
                const o = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (r, i) => {
                    r((0, n.rename)({
                        id: e.id,
                        name: s
                    })), await (0, d.respectAbort)(t, o.renameWatchList(e, s))
                }
            }

            function v(t, e, s, o) {
                const r = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (o, i) => {
                    "custom" === e.type ? (o((0, n.exact)({
                        id: e.id,
                        symbols: s
                    })), await (0, d.respectAbort)(t, r.replaceSymbols(e, s))) : h.logWarn("Trying to modify not a custom watchlist")
                }
            }

            function E(t, e, s, o) {
                const r = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (i, l) => {
                    if ("custom" === e.type) {
                        i((0, n.insert)({
                            id: e.id,
                            symbols: s
                        }));
                        try {
                            await (0, d.respectAbort)(t, r.addSymbols(e, s))
                        } catch (t) {
                            if ((0, d.isAbortError)(t)) throw t;
                            const r = e.symbols.filter(t => !s.includes(t));
                            i((0, n.exact)({
                                id: e.id,
                                symbols: r
                            })), _(t.message, void 0, o)
                        }
                    } else h.logWarn("Trying to modify not a custom watchlist")
                }
            }

            function A(t, e, s) {
                const o = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (r, i) => {
                    r((0, n.exclude)({
                        id: e.id,
                        symbols: s
                    })), await (0, d.respectAbort)(t, o.removeSymbols(e, s))
                }
            }

            function D(t, e) {
                const s = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (o, r) => {
                    await (0, d.respectAbort)(t, s.removeWatchList(e)), o((0, n.remove)({
                        id: e.id
                    }))
                }
            }

            function w(t, e) {
                const s = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (o, n) => {
                    o((0, a.updateActiveList)(e)), await (0, d.respectAbort)(t, s.setActive(e))
                }
            }
            const C = (0, d.respectLatest)((function(t) {
                const e = (0, i.service)(l.SYMBOL_LIST_REPOSITORY_BACKEND_SERVICE);
                return async (s, o) => {
                    try {
                        const o = await (0, d.respectAbort)(t, e.getActive());
                        "custom" !== o.type || s((0, n.put)({
                            id: o.id,
                            name: o.name,
                            description: o.description,
                            symbols: o.symbols,
                            shared: o.shared
                        })), s((0, a.updateActiveList)("custom" === o.type ? o.id : o.color))
                    } catch (t) {
                        (0, d.skipAbortError)(t)
                    }
                }
            }))
        },
        97169: (t, e, s) => {
            function o(t) {
                return t
            }
            s.d(e, {
                asAction: () => o
            })
        },
        1373: (t, e, s) => {
            s.d(e, {
                columnsSelector: () => h,
                getCurrentViewableListByWidgetId: () => E,
                getCustomListById: () => L,
                getCustomLists: () => T,
                getCustomListsMap: () => I,
                getGlobalActiveID: () => u,
                getGlobalActiveSymbolList: () => v,
                getIsReadyCustomLists: () => g,
                highlightedSymbolsSelector: () => b,
                isLoadingSelector: () => A,
                makeGetIsContainedByMultiSelection: () => w,
                positionSelector: () => D,
                scrollToIdSelector: () => S,
                selectedSymbolsSelector: () => m,
                shouldDisplayPositionsSelector: () => _,
                sortingSelector: () => y,
                tickerTypeSelector: () => p,
                widgetOptionsSelector: () => f,
                widgetSelector: () => d
            });
            var o = s(77145),
                n = s(88537),
                r = s(44e3);

            function i(t) {
                return {
                    type: "custom",
                    id: t.id,
                    name: t.name,
                    description: t.description,
                    symbols: t.symbols,
                    shared: t.shared
                }
            }

            function l(t) {
                return t.customLists
            }
            const a = t => t.widgets,
                c = (t, e) => e,
                u = t => t.activeSymbolList,
                d = (0, o.createSelector)([a, c], (t, e) => t[e] || {}),
                m = (0, o.createSelector)(d, t => t.selectedSymbols || []),
                S = (0, o.createSelector)(d, t => t.scrollToId),
                y = (0, o.createSelector)(d, t => t.sorting || null),
                b = (0, o.createSelector)(d, t => t.highlightedSymbols || null),
                h = (0, o.createSelector)(d, t => t.columns),
                p = (0,
                    o.createSelector)(d, t => t.tickerType),
                f = (0, o.createSelector)(d, t => t.options || {}),
                _ = (0, o.createSelector)([f, t => t.isAuthenticated], (t, e) => t.shouldDisplayPositions && !0),
                T = (0, o.createSelector)(l, t => (0, r.getListIds)(t).map(e => i((0, n.ensureNotNull)((0, r.getListById)(t, e))))),
                g = (0, o.createSelector)([l], t => null !== t.timestamp),
                I = (0, o.createSelector)([l], r.getListsMap),
                L = (0, o.createSelector)([l, (t, e) => e], (t, e) => {
                    const s = (0, r.getListById)(t, e);
                    return null === s ? null : i(s)
                }),
                v = (0, o.createSelector)([l, () => null, u], (t, e, s) => {
                    if (null === s) return null; {
                        const e = (0, r.getListById)(t, s);
                        return null === e ? null : i(e)
                    }
                }),
                E = (0, o.createSelector)([() => null, l, () => null, a, c], (t, e, s, o, n) => {
                    const l = o[n];
                    if (void 0 === l) return null;
                    const a = l.listId;
                    if (null === a) return null;
                    const c = (0, r.getListById)(e, a);
                    return null !== c ? i(c) : null
                });
            const A = (0, o.createSelector)([d, E], (t, e) => null === e || t.isLoading || !1),
                D = (0, o.createSelector)([t => t.positions, (t, e) => e], (t, e) => t[e]);

            function w() {
                const t = (0, o.createSelector)([(t, e) => e.widgetId, t => t.widgets], (t, e) => e[t]),
                    e = (0, o.createSelector)(t, t => t.selectedSymbols || []),
                    s = (0, o.createSelector)(e, t => new Set(t));
                return (0, o.createSelector)([s, (t, e) => e.symbol], (t, e) => t.size > 1 && t.has(e))
            }
        },
        7898: (t, e, s) => {
            s.r(e), s.d(e, {
                reorderSymbolsThunk: () => h,
                sortSymbolsThunk: () => p,
                removeSelectedSymbolsThunk: () => f,
                markSymbolsThunk: () => T,
                removeSymbolsThunk: () => g,
                addSymbolsThunk: () => I,
                renameSymbolListThunk: () => E,
                clearSymbolListThunk: () => A,
                findInWatchlistThunk: () => D,
                updateScrollToIdThunk: () => w,
                addSymbolsToCustomListThunk: () => C,
                moveSymbolsToCustomListThunk: () => O,
                insertSymbolBeforeThunk: () => W,
                selectSymbolListThunk: () => B,
                userCreateWatchlistThunk: () => k,
                saveListAsThunk: () => N,
                changeDescriptionThunk: () => P
            });
            var o = s(88537),
                n = s(44e3),
                r = s(25177),
                i = (s(32133), s(19769)),
                l = s(1373),
                a = s(98171),
                c = s(6474),
                u = s(37914),
                d = s(79359),
                m = s(63940),
                S = s(47152),
                y = s(26800),
                b = s(53055);

            function h(t, e) {
                return (s, o) => {
                    const n = o(),
                        {
                            isMovable: r
                        } = (0, l.widgetOptionsSelector)(n, t);
                    if (!r) return;
                    const i = (0, l.getCurrentViewableListByWidgetId)(n, t);
                    if (null !== i && "hot" !== i.type)
                        if ("custom" === i.type) {
                            const t = { ...i,
                                symbols: e
                            };
                            s((0, m.replaceWatchlistSymbolsThunk)(null, t, e))
                        } else 0
                }
            }

            function p(t, e, s) {
                return (r, a) => {
                    const u = a(),
                        d = (0, l.getCurrentViewableListByWidgetId)(u, t);
                    if (null === d) return;
                    if ("hot" === d.type) return;
                    const {
                        symbolsBeforeSorting: S
                    } = (0, l.widgetSelector)(u, t), y = (0, l.sortingSelector)(u, t), b = d.symbols;
                    let h;
                    if (null === e) h = (0, o.ensureNotNull)(S);
                    else {
                        const {
                            column: o,
                            direction: n
                        } = e;
                        h = (0, c.sortSymbols)(t, b, o, n, s)
                    }
                    "custom" === d.type && (r((0, n.exact)({
                        id: d.id,
                        symbols: h
                    })), r((0, m.replaceWatchlistSymbolsThunk)(null, d, h))), r((0, i.updateWidget)(t, {
                        symbolsBeforeSorting: null === y ? [...b] : S,
                        sorting: e
                    }))
                }
            }

            function f(t) {
                return (e, s) => {
                    const o = s(),
                        n = (0, l.getCurrentViewableListByWidgetId)(o, t);
                    if (null === n) return;
                    if ("hot" === n.type) return;
                    const {
                        isDeletable: r
                    } = (0, l.widgetOptionsSelector)(o, t);
                    if (!r) return;
                    const a = (0, l.selectedSymbolsSelector)(o, t);
                    if (0 === a.length) return;
                    const u = a[a.length - 1],
                        d = n.symbols[n.symbols.length - 1],
                        m = n.symbols.some(t => t === u),
                        S = () => {
                            e(m && u !== d ? (0, i.selectNextAvailableSymbol)(t, u, "next", !0) : (0,
                                i.updateWidget)(t, {
                                selectedSymbols: []
                            })), "custom" === n.type && e(_(a, n)), (0, c.trackRemoveEvent)(a.length > 1)
                        };
                    if (1 === a.length) return void S();
                    const y = document.activeElement;
                    (0, b.showConfirm)({
                        text: (0, c.createConfirmRemoveText)(a.length),
                        onConfirm: ({
                            dialogClose: t
                        }) => {
                            S(), t()
                        },
                        onClose: () => {
                            null == y || y.focus()
                        }
                    })
                }
            }

            function _(t, e) {
                return (s, o) => {
                    if ("custom" !== e.type);
                    else {
                        const o = { ...e,
                            symbols: e.symbols.filter(e => !t.includes(e))
                        };
                        s((0, m.removeWatchlistSymbolsThunk)(null, o, t))
                    }
                }
            }

            function T(t, e, s, o) {
                return (t, e) => {}
            }

            function g(t, e, s, o) {
                return (n, r) => {
                    const i = r(),
                        a = s ? (0, l.getCustomListById)(i, s) : (0, l.getCurrentViewableListByWidgetId)(i, t);
                    if (null === a) return;
                    if ("hot" === a.type) return;
                    const u = new Set((0, l.selectedSymbolsSelector)(i, t)),
                        d = u.has(e) && !o ? Array.from(u) : [e],
                        S = () => {
                            "custom" === a.type && n((0, m.removeWatchlistSymbolsThunk)(null, a, d)), (0, c.trackRemoveEvent)(d.length > 1)
                        };
                    if (1 === d.length || Boolean(s)) return void S();
                    const y = document.activeElement;
                    (0, b.showConfirm)({
                        text: (0, c.createConfirmRemoveText)(d.length),
                        onConfirm: ({
                            dialogClose: t
                        }) => {
                            S(), t()
                        },
                        onClose: () => {
                            null == y || y.focus()
                        }
                    })
                }
            }

            function I(t, e, s) {
                return (o, n) => {
                    const r = n(),
                        i = (0, l.getCurrentViewableListByWidgetId)(r, t);
                    if (null === i) return;
                    if ("hot" === i.type) return;
                    u.quoteSessionAdapters.get(t).getSymbolsFullNames(e).then(e => {
                        var n;
                        "custom" === i.type && o(v(e, i, s));
                        const r = null !== (n = e[e.length - 1]) && void 0 !== n ? n : null;
                        o(L(t, e, r))
                    })
                }
            }

            function L(t, e, s) {
                return (o, n) => {
                    e = e.slice(0, 10), o((0, i.updateWidget)(t, {
                        highlightedSymbols: [...e],
                        scrollToId: s ? {
                            id: s
                        } : null
                    })), setTimeout(() => o((0, i.updateWidget)(t, {
                        highlightedSymbols: null
                    })), 500)
                }
            }

            function v(t, e, s, o) {
                return (n, r) => {
                    const i = new Set(e.symbols),
                        l = t.filter(t => !i.has(t) && !i.has((0, y.safeShortName)(t)));
                    if (l.length) {
                        const t = [...e.symbols],
                            r = s ? e.symbols.indexOf(s) : -1; - 1 === r ? t.push(...l) : t.splice(r + 1, 0, ...l);
                        const i = { ...e,
                            symbols: t
                        };
                        n(-1 === r ? (0, m.addWatchlistSymbolsThunk)(null, i, l, o) : (0, m.replaceWatchlistSymbolsThunk)(null, i, t, o))
                    }
                }
            }

            function E(t, e) {
                return (s, n) => {
                    const r = n(); {
                        const n = (0, o.ensureNotNull)((0, l.getCustomListById)(r, t));
                        s((0, m.renameWatchlistThunk)(null, n, e))
                    }
                }
            }

            function A(t) {
                return (e, s) => {
                    const n = s(); {
                        const s = (0, o.ensureNotNull)((0, l.getCustomListById)(n, t));
                        if (0 === s.symbols.length) return;
                        e((0, m.replaceWatchlistSymbolsThunk)(null, { ...s,
                            symbols: []
                        }, []))
                    }
                }
            }

            function D(t, e) {
                return L(t, [e], e)
            }

            function w(t, e) {
                return (s, o) => {
                    const n = o(),
                        r = (0, l.getCurrentViewableListByWidgetId)(n, t);
                    if (!r) return;
                    const {
                        symbols: a
                    } = r;
                    a.includes(e) && s((0, i.updateWidget)(t, {
                        scrollToId: {
                            id: e
                        }
                    }))
                }
            }

            function C(t, e, s, o) {
                return (n, r) => {
                    var i;
                    const c = r(),
                        u = (0, l.getCustomListById)(c, e);
                    if (u) {
                        const r = s.filter(t => !(0, a.isSeparatorItem)(t));
                        if (n(v(r, u, void 0, o)), (0, l.getGlobalActiveID)(c) === e) {
                            const e = null !== (i = r[r.length - 1]) && void 0 !== i ? i : null;
                            n(L(t, r, e))
                        }
                    }
                }
            }

            function O(t, e, s) {
                return async (o, n) => {
                    const r = n(),
                        i = (0, l.getCustomListById)(r, e),
                        c = s.filter(t => !(0, a.isSeparatorItem)(t));
                    i && o(v(c, i));
                    const u = (0, l.getCustomListById)(r, t);
                    u && o((0, m.removeWatchlistSymbolsThunk)(null, u, s))
                }
            }

            function W(t, e, s) {
                return (o, n) => {
                    const r = n(),
                        i = (0, l.getCurrentViewableListByWidgetId)(r, t);
                    if (null === i) return;
                    if ("hot" === i.type) return;
                    const {
                        symbols: a
                    } = i;
                    if (!a.includes(s))
                        if ("custom" === i.type) {
                            const t = a.indexOf(e),
                                n = [...a.slice(0, t), s, ...a.slice(t)],
                                r = { ...i,
                                    symbols: n
                                };
                            o((0, m.replaceWatchlistSymbolsThunk)(null, r, n))
                        } else 0
                }
            }
            const B = (0, S.respectLatest)((function(t, e) {
                return async (t, s) => {
                    try {
                        const n = (0, o.ensureNotNull)((0, l.getCustomListById)(s(), e));
                        t((0, i.updateWidget)(d.WATCHLIST_WIDGET_ID, {
                            isLoading: !1,
                            listId: n.id,
                            sorting: null,
                            symbolsBeforeSorting: null,
                            selectedSymbols: [],
                            scrollToId: null
                        })), t((0, m.setActiveWatchlistThunk)(null, "custom" === n.type ? n.id : n.color))
                    } catch (t) {
                        (0, S.skipAbortError)(t)
                    }
                }
            }));
            const k = (0, S.respectLatest)((function(t, e, s, n) {
                return async (i, a) => {
                    try {
                        if (!(0, c.canUseMultipleLists)()) return;
                        if (!e || void 0 === e.name) {
                            const s = await (0, S.respectAbort)(t, (0, c.createSaveRenameDialog)((0, r.t)("Create New List"), void 0, n)());
                            e = {
                                name: s,
                                symbols: (null == e ? void 0 : e.symbols) || []
                            }
                        }
                        0;
                        const u = (0, m.createWatchlistThunk)(e),
                            d = await (0, S.respectAbort)(t, i(u));
                        if (null === d) return;
                        if (i(B(null, d)), s) {
                            const t = (0, l.getCustomListById)(a(), s);
                            if (!t) return;
                            await i(_((0, o.ensureDefined)(e.symbols), (0, o.ensureDefined)(t)))
                        }
                    } catch (t) {
                        (0, S.skipAbortError)(t)
                    }
                }
            }));

            function N(t, e, s = !0, n) {
                return async (t, i) => {
                    if (!(0, c.canUseMultipleLists)()) return;
                    const a = await (0, c.createSaveRenameDialog)((0, r.t)("Save List As"), n)();
                    if (!e) {
                        const t = (0, o.ensureNotNull)((0, l.getCurrentViewableListByWidgetId)(i(), d.WATCHLIST_WIDGET_ID));
                        e = t.symbols
                    }
                    const u = (0, m.createWatchlistThunk)({
                            name: a,
                            symbols: e
                        }),
                        S = await t(u);
                    null !== S && s && t(B(null, S))
                }
            }

            function P(t, e) {
                return async (t, e) => {}
            }
        },
        6474: (t, e, s) => {
            s.d(e, {
                isValidSeparatorItem: () => y,
                separatorValToDisplayVal: () => b,
                canUseMultipleLists: () => h,
                isImportDataValid: () => p,
                createSaveRenameDialog: () => f,
                sortSymbols: () => T,
                createWatchList: () => L,
                compareSymbols: () => v,
                toPositionRecord: () => E,
                isEqualRecords: () => A,
                getSymbolFromList: () => D,
                findNextAvailableSymbol: () => w,
                trackRemoveEvent: () => C,
                createConfirmRemoveText: () => O
            });
            var o = s(88537),
                n = s(25177),
                r = s(82527),
                i = s(53055),
                l = s(62654),
                a = s(37914),
                c = s(64858),
                u = s(98171),
                d = s(73850),
                m = s(32133),
                S = s(26800);

            function y(t) {
                return (0, u.isSeparatorItem)(t)
            }

            function b(t) {
                return t.replace(d.SEPARATOR_PREFIX, "")
            }

            function h() {
                return r.enabled("multiple_watchlists") && !0
            }

            function p(t) {
                return "string" == typeof t && !/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/.test(t) && !/^[\r\n\t,]*$/.test(t)
            }

            function f(t, e, s) {
                return () => new Promise(o => {
                    (0, i.showRename)({
                        title: t,
                        initValue: e,
                        text: (0, n.t)("Symbol list name") + ":",
                        maxLength: 128,
                        onRename: ({
                            newValue: t,
                            dialogClose: e
                        }) => {
                            o(t), e()
                        }
                    }, s)
                })
            }

            function _(t) {
                return t.replace("−", "-")
            }

            function T(t, e, s, n, r) {
                const i = function(t) {
                    const e = [],
                        s = [];
                    t.forEach((t, e) => {
                        (0, u.isSeparatorItem)(t) && s.push(e)
                    });
                    let o = 0;
                    s.forEach(s => {
                        e.push({
                            values: t.slice(o, s),
                            separator: t[s]
                        }), o = s + 1
                    });
                    const n = s[s.length - 1],
                        r = t.slice(n + 1);
                    return r.length > 0 && e.push({
                        values: r,
                        separator: null
                    }), e
                }(e);
                return i.forEach(e => {
                        e.values.sort((e, i) => {
                            const u = a.quoteSessionAdapters.get(t).getLastSymbolData(e),
                                d = a.quoteSessionAdapters.get(t).getLastSymbolData(i),
                                m = g(u),
                                y = g(d),
                                b = (t, e) => {
                                    if (!t || "flag" === s) return;
                                    var o;
                                    return "error" === t.status ? void 0 : r === l.TickerType.Description && "short_name" === s ? (o = t.values, (0, c.getTranslatedSymbolDescription)(o) || (0, S.safeShortName)(e)) : t.values[s]
                                },
                                h = b(u, e),
                                p = b(d, i);
                            return function(t, e) {
                                const s = -1 === e ? -1 / 0 : 1 / 0;
                                return (n, r, i, l) => {
                                    if ("rchp" !== t) {
                                        if (void 0 === n && void 0 === r) return 0;
                                        if (void 0 === n) return -e;
                                        if (void 0 === r) return e
                                    }
                                    switch (t) {
                                        case "short_name":
                                            return e * (n === r ? 0 : (0, o.ensure)(n) < (0, o.ensure)(r) ? -1 : 1);
                                        case "rchp":
                                            return i || (n = void 0), l || (r = void 0), I(n, r, e, s);
                                        case "last_price":
                                        case "change":
                                        case "change_percent":
                                            return I(n, r, e, s);
                                        case "volume":
                                            {
                                                const t = (0, o.ensure)(n) >= 1e100 ? s : Number(n),
                                                    i = (0, o.ensure)(r) >= 1e100 ? s : Number(r);
                                                return e * (t - i)
                                            }
                                        default:
                                            return (0, o.ensure)(n) > (0, o.ensure)(r) ? -1 : 1
                                    }
                                }
                            }(s, n)(h, p, m, y)
                        })
                    }),
                    function(t) {
                        const e = [];
                        return t.forEach(({
                            values: t,
                            separator: s
                        }) => {
                            e.push(...t), null !== s && e.push(s)
                        }), e
                    }(i)
            }

            function g(t) {
                if (!t) return !1;
                const e = "pre_market" === t.values.current_session,
                    s = "post_market" === t.values.current_session;
                return e || s
            }

            function I(t, e, s, o) {
                let n = parseFloat(_(String(t))),
                    r = parseFloat(_(String(e)));
                return n = isNaN(n) ? o : n, r = isNaN(r) ? o : r, s * (n - r)
            }

            function L(t, e, s) {
                return {
                    type: "custom",
                    id: t,
                    name: e,
                    description: null,
                    symbols: s,
                    shared: !1
                }
            }

            function v(t, e) {
                return t === e || (0, S.safeShortName)(t) === e
            }

            function E(t) {
                return {
                    symbol: t.symbol,
                    side: t.side,
                    qty: t.qty,
                    avgPrice: t.avgPrice
                }
            }

            function A(t, e) {
                return t === e || void 0 !== t && void 0 !== e && (t.side === e.side && t.qty === e.qty && t.avgPrice === e.avgPrice && t.symbol === e.symbol)
            }

            function D(t, e) {
                if (e.includes(t)) return t; {
                    const s = (0, S.safeShortName)(t);
                    if (e.includes(s)) return s
                }
            }

            function w(t, e, s) {
                const o = "next" === s;
                for (let s = t; o ? s < e.length : s >= 0; o ? s++ : s--)
                    if (!(0, u.isSeparatorItem)(e[s]) && s !== t) return e[s];
                for (let s = o ? 0 : e.length - 1; o ? s < t : s > t; o ? s++ : s--)
                    if (!(0, u.isSeparatorItem)(e[s])) return e[s]
            }

            function C(t) {
                t ? (0, m.trackEvent)("Watchlist", "Multi select", "Remove") : (0, m.trackEvent)("Watchlist", "Remove")
            }

            function O(t) {
                return (0, n.t)("Do you really want to delete {count} selected symbol?", {
                    plural: "Do you really want to delete {count} selected symbols?",
                    context: "symbols_and_drawings_count",
                    count: t,
                    replace: {
                        count: t.toString()
                    }
                })
            }
        },
        98171: (t, e, s) => {
            function o(t) {
                return !1
            }
            s.d(e, {
                isSeparatorItem: () => o
            })
        },
        26800: (t, e, s) => {
            s.d(e, {
                safeShortName: () => n
            });
            var o = s(10248);

            function n(t) {
                try {
                    return (0, o.shortName)(t)
                } catch (e) {
                    return t
                }
            }
        }
    }
]);
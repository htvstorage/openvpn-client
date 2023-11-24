const { parentPort } = require("worker_threads");
const WebSocket = require('ws');
const fs = require('fs')
const moment = require('moment')
const xlsx = require("xlsx")
const numeral = require('numeral');
const { map, map10, map20, largeCap, midCap, smallCap, mapCap } = require('./symbols.js')
let ws = null;

function formatDateToYYMM(date) {
  const year = date.getFullYear().toString().slice(-2);
  const month = (date.getMonth() + 1).toString().padStart(2, '0'); // Month is zero-based
  return year + month;
}

function getNextMonth(date) {
  const currentDate = new Date(date);
  let currentMonth = currentDate.getMonth();
  let nextMonth = currentMonth + 1;
  if (nextMonth > 11) {
    nextMonth = 0; // January
    currentDate.setFullYear(currentDate.getFullYear() + 1); // Move to the next year
  }
  // Set the date to the first day of the next month
  currentDate.setMonth(nextMonth, 1);
  return currentDate;
}

function getPairVN30Feature() {
 return [formatDateToYYMM(new Date()),
  formatDateToYYMM(getNextMonth(new Date())),
  formatDateToYYMM(getNextMonth(getNextMonth(new Date()))),].map(e=>'VN30F'+e).map(e=>'"'+e+'"')
}

async function wss() {
  ws = new WebSocket('wss://iboard-pushstream.ssi.com.vn/realtime');
  ws.on('open', function () {
    console.log('WebSocket connection established');
    ws.send('{"type":"sub","topic":"serverName"}');
    ws.send('{"type":"sub","topic":"systemStatusChanged"}');
    ws.send('{"type":"init"}');
    ws.send('{"type":"sub","topic":"matchedVolByPriceV2","variables":["AAA","AAM","AAT","ABR","ABS","ABT","ACB","ACC","ACG","ACL","ADG","ADP","ADS","AGG","AGM","AGR","ANV","APC","APG","APH","ASG","ASM","ASP","AST","BAF","BBC","BCE","BCG","BCM","BFC","BHN","BIC","BID","BKG","BMC","BMI","BMP","BRC","BSI","BTP","BTT","BVH","BWE","C32","C47","CAV","CCI","CCL","CDC","CHP","CIG","CII","CKG","CLC","CLL","CLW","CMG","CMV","CMX","CNG","COM","CRC","CRE","CSM","CSV","CTD","CTF","CTG","CTI","CTR","CTS","CVT","D2D","DAG","DAH","DAT","DBC","DBD","DBT","DC4","DCL","DCM","DGC","DGW","DHA","DHC","DHG","DHM","DIG","DLG","DMC","DPG","DPM","DPR","DQC","DRC","DRH","DRL","DSN","DTA","DTL","DTT","DVP","DXG","DXS","DXV","EIB","ELC","EVE","EVF","EVG","FCM","FCN","FDC","FIR","FIT","FMC","FPT","FRT","FTS","GAS","GDT","GEG","GEX","GIL","GMC","GMD","GMH","GSP","GTA","GVR","HAG","HAH","HAP","HAR","HAS","HAX","HBC","HCD","HCM","HDB","HDC","HDG","HHP","HHS","HHV","HID","HII","HMC","HNG","HPG","HPX","HQC","HRC","HSG","HSL","HT1","HTI","HTL","HTN","HTV","HU1","HUB","HVH","HVN","HVX","IBC","ICT","IDI","IJC","ILB","IMP","ITA","ITC","ITD","JVC","KBC","KDC","KDH","KHG","KHP","KMR","KOS","KPF","KSB","L10","LAF","LBM","LCG","LDG","LEC","LGC","LGL","LHG","LIX","LM8","LPB","LSS","MBB","MCP","MDG","MHC","MIG","MSB","MSH","MSN","MWG","NAF","NAV","NBB","NCT","NHA","NHH","NHT","NKG","NLG","NNC","NO1","NSC","NT2","NTL","NVL","NVT","OCB","OGC","OPC","ORS","PAC","PAN","PC1","PDN","PDR","PET","PGC","PGD","PGI","PGV","PHC","PHR","PIT","PJT","PLP","PLX","PMG","PNC","PNJ","POM","POW","PPC","PSH","PTB","PTC","PTL","PVD","PVP","PVT","QBS","QCG","RAL","RDP","REE","S4A","SAB","SAM","SAV","SBA","SBT","SBV","SC5","SCD","SCR","SCS","SFC","SFG","SFI","SGN","SGR","SGT","SHA","SHB","SHI","SHP","SIP","SJD","SJF","SJS","SKG","SMA","SMB","SMC","SPM","SRC","SRF","SSB","SSC","SSI","ST8","STB","STG","STK","SVC","SVD","SVI","SVT","SZC","SZL","TBC","TCB","TCD","TCH","TCL","TCM","TCO","TCR","TCT","TDC","TDG","TDH","TDM","TDP","TDW","TEG","TGG","THG","TIP","TIX","TLD","TLG","TLH","TMP","TMS","TMT","TN1","TNA","TNC","TNH","TNI","TNT","TPB","TPC","TRA","TRC","TSC","TTA","TTB","TTE","TTF","TV2","TVB","TVS","TVT","TYA","UIC","VAF","VCA","VCB","VCF","VCG","VCI","VDP","VDS","VFG","VGC","VHC","VHM","VIB","VIC","VID","VIP","VIX","VJC","VMD","VND","VNE","VNG","VNL","VNM","VNS","VOS","VPB","VPD","VPG","VPH","VPI","VPS","VRC","VRE","VSC","VSH","VSI","VTB","VTO","YBM","YEG","AAV","ADC","ALT","AMC","AME","AMV","API","APS","ARM","ATS","BAB","BAX","BBS","BCC","BCF","BDB","BED","BKC","BLF","BNA","BPC","BSC","BST","BTS","BTW","BVS","BXH","C69","CAG","CAN","CAP","CCR","CDN","CEO","CET","CIA","CJC","CKV","CLH","CLM","CMC","CMS","CPC","CSC","CTB","CTC","CTP","CTT","CTX","CVN","CX8","D11","DAD","DAE","DC2","DDG","DHP","DHT","DIH","DL1","DNC","DNP","DP3","DPC","DS3","DST","DTC","DTD","DTG","DTK","DVG","DVM","DXP","DZM","EBS","ECI","EID","EVS","FID","GDW","GIC","GKM","GLT","GMA","GMX","HAD","HAT","HBS","HCC","HCT","HDA","HEV","HGM","HHC","HJS","HKT","HLC","HLD","HMH","HMR","HOM","HTC","HTP","HUT","HVT","ICG","IDC","IDJ","IDV","INC","INN","IPA","ITQ","IVS","KDM","KHS","KKC","KLF","KMT","KSD","KSF","KSQ","KST","KSV","KTS","KTT","L14","L18","L40","L43","L61","L62","LAS","LBE","LCD","LDP","LHC","LIG","MAC","MAS","MBG","MBS","MCC","MCF","MCO","MDC","MED","MEL","MHL","MIM","MKV","MST","MVB","NAG","NAP","NBC","NBP","NBW","NDN","NDX","NET","NFC","NHC","NRC","NSH","NST","NTH","NTP","NVB","OCH","ONE","PBP","PCE","PCG","PCH","PCT","PDB","PEN","PGN","PGS","PGT","PHN","PIA","PIC","PJC","PLC","PMB","PMC","PMP","PMS","POT","PPE","PPP","PPS","PPT","PPY","PRC","PRE","PSC","PSD","PSE","PSI","PSW","PTD","PTI","PTS","PV2","PVB","PVC","PVG","PVI","PVS","QHD","QST","QTC","RCL","S55","S99","SAF","SCG","SCI","SD5","SD6","SD9","SDA","SDC","SDG","SDN","SDT","SDU","SEB","SED","SFN","SGC","SGD","SGH","SHE","SHN","SHS","SJ1","SJE","SLS","SMN","SMT","SPC","SPI","SRA","SSM","STC","STP","SVN","SZB","TA9","TAR","TBX","TC6","TDN","TDT","TET","TFC","THB","THD","THS","THT","TIG","TJC","TKC","TKG","TKU","TMB","TMC","TMX","TNG","TOT","TPH","TPP","TSB","TTC","TTH","TTL","TTT","TTZ","TV3","TV4","TVC","TVD","TXM","UNI","V12","V21","VBC","VC1","VC2","VC3","VC6","VC7","VC9","VCC","VCM","VCS","VDL","VE1","VE3","VE4","VE8","VFS","VGP","VGS","VHE","VHL","VIF","VIG","VIT","VLA","VMC","VMS","VNC","VNF","VNR","VNT","VSA","VSM","VTC","VTH","VTJ","VTV","VTZ","WCS","WSS","X20","A32","AAS","ABB","ABC","ABI","ABW","ACE","ACM","ACS","ACV","AFX","AG1","AGF","AGP","AGX","AIC","ALV","AMD","AMP","AMS","ANT","APF","APL","APP","APT","ART","ASA","ATA","ATB","ATG","AVC","AVF","B82","BAL","BBH","BBM","BBT","BCA","BCB","BCP","BCV","BDG","BDT","BDW","BEL","BGW","BHA","BHC","BHG","BHI","BHK","BHP","BIG","BII","BIO","BLI","BLN","BLT","BLW","BMD","BMF","BMG","BMJ","BMN","BMS","BMV","BNW","BOT","BQB","BRR","BRS","BSA","BSD","BSG","BSH","BSL","BSP","BSQ","BSR","BT1","BT6","BTB","BTD","BTG","BTH","BTN","BTU","BTV","BVB","BVG","BVL","BVN","BWA","BWS","C12","C21","C22","C4G","C92","CAB","CAD","CAR","CAT","CBI","CBS","CC1","CC4","CCA","CCM","CCP","CCT","CCV","CDG","CDH","CDO","CDP","CDR","CE1","CEG","CEN","CFM","CFV","CGV","CH5","CHC","CHS","CI5","CID","CIP","CK8","CKA","CKD","CLG","CLX","CMD","CMF","CMI","CMK","CMM","CMN","CMP","CMT","CMW","CNA","CNC","CNN","CNT","CPA","CPH","CPI","CQN","CQT","CSI","CST","CT3","CT6","CTA","CTN","CTW","CYC","DAC","DAN","DAS","DBM","DC1","DCF","DCG","DCH","DCR","DCS","DCT","DDH","DDM","DDN","DDV","DFC","DFF","DGT","DHB","DHD","DHN","DIC","DID","DKC","DLD","DLM","DLR","DLT","DM7","DMN","DMS","DNA","DND","DNE","DNH","DNL","DNM","DNN","DNT","DNW","DOC","DOP","DP1","DP2","DPH","DPP","DPS","DRG","DRI","DSC","DSD","DSG","DSP","DSV","DTB","DTE","DTH","DTI","DTP","DTV","DUS","DVC","DVN","DVW","DWC","DWS","DXL","E12","E29","EFI","EIC","EIN","EME","EMG","EMS","EPC","EPH","FBA","FBC","FCC","FCS","FGL","FHN","FHS","FIC","FLC","FOC","FOX","FRC","FRM","FSO","FT1","FTI","FTM","G20","G36","GAB","GCB","GCF","GDA","GEE","GER","GGG","GH3","GHC","GLC","GLW","GND","GPC","GSM","GTD","GTS","GTT","GVT","H11","HAC","HAF","HAI","HAM","HAN","HAV","HBD","HBH","HC1","HC3","HCB","HCI","HD2","HD6","HD8","HDM","HDO","HDP","HDW","HEC","HEJ","HEM","HEP","HES","HFB","HFC","HFX","HGT","HGW","HHG","HHN","HHR","HIG","HJC","HKB","HLA","HLB","HLR","HLS","HLT","HLY","HMG","HMS","HNA","HNB","HND","HNF","HNI","HNM","HNP","HNR","HOT","HPB","HPD","HPH","HPI","HPM","HPP","HPT","HPW","HRB","HRT","HSA","HSI","HSM","HSP","HSV","HTE","HTG","HTM","HTT","HU3","HU4","HU6","HUG","HVA","HVG","HWS","IBD","ICC","ICF","ICI","ICN","IDP","IFS","IHK","ILA","ILC","ILS","IME","IN4","IRC","ISG","ISH","IST","ITS","JOS","KAC","KCB","KCE","KGM","KHD","KHL","KHW","KIP","KLB","KLM","KSH","KTC","KTL","KVC","L12","L35","L44","L45","L63","LAI","LAW","LBC","LCC","LCM","LCS","LDW","LG9","LGM","LIC","LKW","LLM","LM3","LM7","LMC","LMH","LMI","LNC","LO5","LPT","LQN","LSG","LTC","LTG","LUT","M10","MA1","MBN","MCD","MCG","MCH","MCM","MDA","MDF","MEC","MEF","MES","MFS","MGC","MGG","MGR","MH3","MIC","MIE","MKP","MLC","MLS","MML","MNB","MND","MPC","MPT","MPY","MQB","MQN","MRF","MSR","MTA","MTB","MTC","MTG","MTH","MTL","MTP","MTS","MTV","MVC","MVN","NAB","NAC","NAS","NAU","NAW","NBE","NBT","NCS","ND2","NDC","NDF","NDP","NDT","NDW","NED","NGC","NHP","NHV","NJC","NLS","NNT","NOS","NQB","NQN","NQT","NS2","NSG","NSL","NSS","NTB","NTC","NTF","NTT","NTW","NUE","NVP","NWT","NXT","ODE","OIL","ONW","PAI","PAP","PAS","PAT","PBC","PBT","PCC","PCF","PCM","PCN","PDC","PDV","PEC","PEG","PEQ","PFL","PGB","PHH","PHP","PHS","PID","PIS","PIV","PJS","PLA","PLE","PLO","PMJ","PMT","PMW","PND","PNG","PNP","PNT","POB","POS","POV","PPH","PPI","PQN","PRO","PRT","PSB","PSG","PSL","PSN","PSP","PTE","PTG","PTH","PTN","PTO","PTP","PTT","PTV","PTX","PVA","PVE","PVH","PVL","PVM","PVO","PVR","PVV","PVX","PVY","PWA","PWS","PX1","PXA","PXC","PXI","PXL","PXM","PXS","PXT","QCC","QHW","QNC","QNS","QNT","QNU","QNW","QPH","QSP","QTP","RAT","RBC","RCC","RCD","RGC","RIC","RTB","S12","S27","S72","S74","S96","SAC","SAL","SAP","SAS","SB1","SBD","SBH","SBL","SBM","SBR","SBS","SCC","SCJ","SCL","SCO","SCY","SD1","SD2","SD3","SD4","SD7","SD8","SDB","SDD","SDJ","SDK","SDP","SDV","SDX","SDY","SEA","SEP","SGB","SGI","SGO","SGP","SGS","SHC","SHG","SHX","SID","SIG","SII","SIV","SJC","SJG","SJM","SKH","SKN","SKV","SNC","SNZ","SP2","SPB","SPD","SPH","SPV","SQC","SRB","SRT","SSF","SSG","SSH","SSN","STH","STL","STS","STT","STW","SVG","SVH","SWC","SZE","SZG","TA3","TA6","TAN","TAW","TB8","TBD","TBH","TBR","TBT","TCI","TCJ","TCK","TCW","TDB","TDF","TDS","TED","TEL","TGP","TH1","THN","THP","THU","THW","TID","TIE","TIN","TIS","TKA","TL4","TLI","TLP","TLT","TMG","TMW","TNB","TNM","TNP","TNS","TNW","TOP","TOS","TOW","TPS","TQN","TQW","TR1","TRS","TRT","TS3","TS4","TSD","TSG","TSJ","TST","TTD","TTG","TTN","TTP","TTS","TUG","TV1","TV6","TVA","TVG","TVH","TVM","TVN","TVP","TW3","UCT","UDC","UDJ","UDL","UEM","UMC","UPC","UPH","USC","USD","V11","V15","VAB","VAV","VBB","VBG","VBH","VC5","VCE","VCP","VCR","VCT","VCW","VCX","VDB","VDN","VDT","VE2","VE9","VEA","VEC","VEF","VES","VET","VFC","VFR","VGG","VGI","VGL","VGR","VGT","VGV","VHD","VHF","VHG","VHH","VIE","VIH","VIM","VIN","VIR","VIW","VKC","VKP","VLB","VLC","VLF","VLG","VLP","VLW","VMA","VMG","VMT","VNA","VNB","VNH","VNI","VNP","VNX","VNY","VNZ","VOC","VPA","VPC","VPR","VPW","VQC","VRG","VSE","VSF","VSG","VSN","VST","VTA","VTD","VTE","VTG","VTI","VTK","VTL","VTM","VTP","VTQ","VTR","VTS","VTX","VUA","VVN","VVS","VW3","VWS","VXB","VXP","VXT","WSB","WTC","X26","X77","XDC","XDH","XHC","XLV","XMC","XMD","XMP","XPH","YBC","YTC"]}');
    ws.send('{"type":"sub","topic":"leTableAddV2","variables":["AAA","AAM","AAT","ABR","ABS","ABT","ACB","ACC","ACG","ACL","ADG","ADP","ADS","AGG","AGM","AGR","ANV","APC","APG","APH","ASG","ASM","ASP","AST","BAF","BBC","BCE","BCG","BCM","BFC","BHN","BIC","BID","BKG","BMC","BMI","BMP","BRC","BSI","BTP","BTT","BVH","BWE","C32","C47","CAV","CCI","CCL","CDC","CHP","CIG","CII","CKG","CLC","CLL","CLW","CMG","CMV","CMX","CNG","COM","CRC","CRE","CSM","CSV","CTD","CTF","CTG","CTI","CTR","CTS","CVT","D2D","DAG","DAH","DAT","DBC","DBD","DBT","DC4","DCL","DCM","DGC","DGW","DHA","DHC","DHG","DHM","DIG","DLG","DMC","DPG","DPM","DPR","DQC","DRC","DRH","DRL","DSN","DTA","DTL","DTT","DVP","DXG","DXS","DXV","EIB","ELC","EVE","EVF","EVG","FCM","FCN","FDC","FIR","FIT","FMC","FPT","FRT","FTS","GAS","GDT","GEG","GEX","GIL","GMC","GMD","GMH","GSP","GTA","GVR","HAG","HAH","HAP","HAR","HAS","HAX","HBC","HCD","HCM","HDB","HDC","HDG","HHP","HHS","HHV","HID","HII","HMC","HNG","HPG","HPX","HQC","HRC","HSG","HSL","HT1","HTI","HTL","HTN","HTV","HU1","HUB","HVH","HVN","HVX","IBC","ICT","IDI","IJC","ILB","IMP","ITA","ITC","ITD","JVC","KBC","KDC","KDH","KHG","KHP","KMR","KOS","KPF","KSB","L10","LAF","LBM","LCG","LDG","LEC","LGC","LGL","LHG","LIX","LM8","LPB","LSS","MBB","MCP","MDG","MHC","MIG","MSB","MSH","MSN","MWG","NAF","NAV","NBB","NCT","NHA","NHH","NHT","NKG","NLG","NNC","NO1","NSC","NT2","NTL","NVL","NVT","OCB","OGC","OPC","ORS","PAC","PAN","PC1","PDN","PDR","PET","PGC","PGD","PGI","PGV","PHC","PHR","PIT","PJT","PLP","PLX","PMG","PNC","PNJ","POM","POW","PPC","PSH","PTB","PTC","PTL","PVD","PVP","PVT","QBS","QCG","RAL","RDP","REE","S4A","SAB","SAM","SAV","SBA","SBT","SBV","SC5","SCD","SCR","SCS","SFC","SFG","SFI","SGN","SGR","SGT","SHA","SHB","SHI","SHP","SIP","SJD","SJF","SJS","SKG","SMA","SMB","SMC","SPM","SRC","SRF","SSB","SSC","SSI","ST8","STB","STG","STK","SVC","SVD","SVI","SVT","SZC","SZL","TBC","TCB","TCD","TCH","TCL","TCM","TCO","TCR","TCT","TDC","TDG","TDH","TDM","TDP","TDW","TEG","TGG","THG","TIP","TIX","TLD","TLG","TLH","TMP","TMS","TMT","TN1","TNA","TNC","TNH","TNI","TNT","TPB","TPC","TRA","TRC","TSC","TTA","TTB","TTE","TTF","TV2","TVB","TVS","TVT","TYA","UIC","VAF","VCA","VCB","VCF","VCG","VCI","VDP","VDS","VFG","VGC","VHC","VHM","VIB","VIC","VID","VIP","VIX","VJC","VMD","VND","VNE","VNG","VNL","VNM","VNS","VOS","VPB","VPD","VPG","VPH","VPI","VPS","VRC","VRE","VSC","VSH","VSI","VTB","VTO","YBM","YEG","AAV","ADC","ALT","AMC","AME","AMV","API","APS","ARM","ATS","BAB","BAX","BBS","BCC","BCF","BDB","BED","BKC","BLF","BNA","BPC","BSC","BST","BTS","BTW","BVS","BXH","C69","CAG","CAN","CAP","CCR","CDN","CEO","CET","CIA","CJC","CKV","CLH","CLM","CMC","CMS","CPC","CSC","CTB","CTC","CTP","CTT","CTX","CVN","CX8","D11","DAD","DAE","DC2","DDG","DHP","DHT","DIH","DL1","DNC","DNP","DP3","DPC","DS3","DST","DTC","DTD","DTG","DTK","DVG","DVM","DXP","DZM","EBS","ECI","EID","EVS","FID","GDW","GIC","GKM","GLT","GMA","GMX","HAD","HAT","HBS","HCC","HCT","HDA","HEV","HGM","HHC","HJS","HKT","HLC","HLD","HMH","HMR","HOM","HTC","HTP","HUT","HVT","ICG","IDC","IDJ","IDV","INC","INN","IPA","ITQ","IVS","KDM","KHS","KKC","KLF","KMT","KSD","KSF","KSQ","KST","KSV","KTS","KTT","L14","L18","L40","L43","L61","L62","LAS","LBE","LCD","LDP","LHC","LIG","MAC","MAS","MBG","MBS","MCC","MCF","MCO","MDC","MED","MEL","MHL","MIM","MKV","MST","MVB","NAG","NAP","NBC","NBP","NBW","NDN","NDX","NET","NFC","NHC","NRC","NSH","NST","NTH","NTP","NVB","OCH","ONE","PBP","PCE","PCG","PCH","PCT","PDB","PEN","PGN","PGS","PGT","PHN","PIA","PIC","PJC","PLC","PMB","PMC","PMP","PMS","POT","PPE","PPP","PPS","PPT","PPY","PRC","PRE","PSC","PSD","PSE","PSI","PSW","PTD","PTI","PTS","PV2","PVB","PVC","PVG","PVI","PVS","QHD","QST","QTC","RCL","S55","S99","SAF","SCG","SCI","SD5","SD6","SD9","SDA","SDC","SDG","SDN","SDT","SDU","SEB","SED","SFN","SGC","SGD","SGH","SHE","SHN","SHS","SJ1","SJE","SLS","SMN","SMT","SPC","SPI","SRA","SSM","STC","STP","SVN","SZB","TA9","TAR","TBX","TC6","TDN","TDT","TET","TFC","THB","THD","THS","THT","TIG","TJC","TKC","TKG","TKU","TMB","TMC","TMX","TNG","TOT","TPH","TPP","TSB","TTC","TTH","TTL","TTT","TTZ","TV3","TV4","TVC","TVD","TXM","UNI","V12","V21","VBC","VC1","VC2","VC3","VC6","VC7","VC9","VCC","VCM","VCS","VDL","VE1","VE3","VE4","VE8","VFS","VGP","VGS","VHE","VHL","VIF","VIG","VIT","VLA","VMC","VMS","VNC","VNF","VNR","VNT","VSA","VSM","VTC","VTH","VTJ","VTV","VTZ","WCS","WSS","X20","A32","AAS","ABB","ABC","ABI","ABW","ACE","ACM","ACS","ACV","AFX","AG1","AGF","AGP","AGX","AIC","ALV","AMD","AMP","AMS","ANT","APF","APL","APP","APT","ART","ASA","ATA","ATB","ATG","AVC","AVF","B82","BAL","BBH","BBM","BBT","BCA","BCB","BCP","BCV","BDG","BDT","BDW","BEL","BGW","BHA","BHC","BHG","BHI","BHK","BHP","BIG","BII","BIO","BLI","BLN","BLT","BLW","BMD","BMF","BMG","BMJ","BMN","BMS","BMV","BNW","BOT","BQB","BRR","BRS","BSA","BSD","BSG","BSH","BSL","BSP","BSQ","BSR","BT1","BT6","BTB","BTD","BTG","BTH","BTN","BTU","BTV","BVB","BVG","BVL","BVN","BWA","BWS","C12","C21","C22","C4G","C92","CAB","CAD","CAR","CAT","CBI","CBS","CC1","CC4","CCA","CCM","CCP","CCT","CCV","CDG","CDH","CDO","CDP","CDR","CE1","CEG","CEN","CFM","CFV","CGV","CH5","CHC","CHS","CI5","CID","CIP","CK8","CKA","CKD","CLG","CLX","CMD","CMF","CMI","CMK","CMM","CMN","CMP","CMT","CMW","CNA","CNC","CNN","CNT","CPA","CPH","CPI","CQN","CQT","CSI","CST","CT3","CT6","CTA","CTN","CTW","CYC","DAC","DAN","DAS","DBM","DC1","DCF","DCG","DCH","DCR","DCS","DCT","DDH","DDM","DDN","DDV","DFC","DFF","DGT","DHB","DHD","DHN","DIC","DID","DKC","DLD","DLM","DLR","DLT","DM7","DMN","DMS","DNA","DND","DNE","DNH","DNL","DNM","DNN","DNT","DNW","DOC","DOP","DP1","DP2","DPH","DPP","DPS","DRG","DRI","DSC","DSD","DSG","DSP","DSV","DTB","DTE","DTH","DTI","DTP","DTV","DUS","DVC","DVN","DVW","DWC","DWS","DXL","E12","E29","EFI","EIC","EIN","EME","EMG","EMS","EPC","EPH","FBA","FBC","FCC","FCS","FGL","FHN","FHS","FIC","FLC","FOC","FOX","FRC","FRM","FSO","FT1","FTI","FTM","G20","G36","GAB","GCB","GCF","GDA","GEE","GER","GGG","GH3","GHC","GLC","GLW","GND","GPC","GSM","GTD","GTS","GTT","GVT","H11","HAC","HAF","HAI","HAM","HAN","HAV","HBD","HBH","HC1","HC3","HCB","HCI","HD2","HD6","HD8","HDM","HDO","HDP","HDW","HEC","HEJ","HEM","HEP","HES","HFB","HFC","HFX","HGT","HGW","HHG","HHN","HHR","HIG","HJC","HKB","HLA","HLB","HLR","HLS","HLT","HLY","HMG","HMS","HNA","HNB","HND","HNF","HNI","HNM","HNP","HNR","HOT","HPB","HPD","HPH","HPI","HPM","HPP","HPT","HPW","HRB","HRT","HSA","HSI","HSM","HSP","HSV","HTE","HTG","HTM","HTT","HU3","HU4","HU6","HUG","HVA","HVG","HWS","IBD","ICC","ICF","ICI","ICN","IDP","IFS","IHK","ILA","ILC","ILS","IME","IN4","IRC","ISG","ISH","IST","ITS","JOS","KAC","KCB","KCE","KGM","KHD","KHL","KHW","KIP","KLB","KLM","KSH","KTC","KTL","KVC","L12","L35","L44","L45","L63","LAI","LAW","LBC","LCC","LCM","LCS","LDW","LG9","LGM","LIC","LKW","LLM","LM3","LM7","LMC","LMH","LMI","LNC","LO5","LPT","LQN","LSG","LTC","LTG","LUT","M10","MA1","MBN","MCD","MCG","MCH","MCM","MDA","MDF","MEC","MEF","MES","MFS","MGC","MGG","MGR","MH3","MIC","MIE","MKP","MLC","MLS","MML","MNB","MND","MPC","MPT","MPY","MQB","MQN","MRF","MSR","MTA","MTB","MTC","MTG","MTH","MTL","MTP","MTS","MTV","MVC","MVN","NAB","NAC","NAS","NAU","NAW","NBE","NBT","NCS","ND2","NDC","NDF","NDP","NDT","NDW","NED","NGC","NHP","NHV","NJC","NLS","NNT","NOS","NQB","NQN","NQT","NS2","NSG","NSL","NSS","NTB","NTC","NTF","NTT","NTW","NUE","NVP","NWT","NXT","ODE","OIL","ONW","PAI","PAP","PAS","PAT","PBC","PBT","PCC","PCF","PCM","PCN","PDC","PDV","PEC","PEG","PEQ","PFL","PGB","PHH","PHP","PHS","PID","PIS","PIV","PJS","PLA","PLE","PLO","PMJ","PMT","PMW","PND","PNG","PNP","PNT","POB","POS","POV","PPH","PPI","PQN","PRO","PRT","PSB","PSG","PSL","PSN","PSP","PTE","PTG","PTH","PTN","PTO","PTP","PTT","PTV","PTX","PVA","PVE","PVH","PVL","PVM","PVO","PVR","PVV","PVX","PVY","PWA","PWS","PX1","PXA","PXC","PXI","PXL","PXM","PXS","PXT","QCC","QHW","QNC","QNS","QNT","QNU","QNW","QPH","QSP","QTP","RAT","RBC","RCC","RCD","RGC","RIC","RTB","S12","S27","S72","S74","S96","SAC","SAL","SAP","SAS","SB1","SBD","SBH","SBL","SBM","SBR","SBS","SCC","SCJ","SCL","SCO","SCY","SD1","SD2","SD3","SD4","SD7","SD8","SDB","SDD","SDJ","SDK","SDP","SDV","SDX","SDY","SEA","SEP","SGB","SGI","SGO","SGP","SGS","SHC","SHG","SHX","SID","SIG","SII","SIV","SJC","SJG","SJM","SKH","SKN","SKV","SNC","SNZ","SP2","SPB","SPD","SPH","SPV","SQC","SRB","SRT","SSF","SSG","SSH","SSN","STH","STL","STS","STT","STW","SVG","SVH","SWC","SZE","SZG","TA3","TA6","TAN","TAW","TB8","TBD","TBH","TBR","TBT","TCI","TCJ","TCK","TCW","TDB","TDF","TDS","TED","TEL","TGP","TH1","THN","THP","THU","THW","TID","TIE","TIN","TIS","TKA","TL4","TLI","TLP","TLT","TMG","TMW","TNB","TNM","TNP","TNS","TNW","TOP","TOS","TOW","TPS","TQN","TQW","TR1","TRS","TRT","TS3","TS4","TSD","TSG","TSJ","TST","TTD","TTG","TTN","TTP","TTS","TUG","TV1","TV6","TVA","TVG","TVH","TVM","TVN","TVP","TW3","UCT","UDC","UDJ","UDL","UEM","UMC","UPC","UPH","USC","USD","V11","V15","VAB","VAV","VBB","VBG","VBH","VC5","VCE","VCP","VCR","VCT","VCW","VCX","VDB","VDN","VDT","VE2","VE9","VEA","VEC","VEF","VES","VET","VFC","VFR","VGG","VGI","VGL","VGR","VGT","VGV","VHD","VHF","VHG","VHH","VIE","VIH","VIM","VIN","VIR","VIW","VKC","VKP","VLB","VLC","VLF","VLG","VLP","VLW","VMA","VMG","VMT","VNA","VNB","VNH","VNI","VNP","VNX","VNY","VNZ","VOC","VPA","VPC","VPR","VPW","VQC","VRG","VSE","VSF","VSG","VSN","VST","VTA","VTD","VTE","VTG","VTI","VTK","VTL","VTM","VTP","VTQ","VTR","VTS","VTX","VUA","VVN","VVS","VW3","VWS","VXB","VXP","VXT","WSB","WTC","X26","X77","XDC","XDH","XHC","XLV","XMC","XMD","XMP","XPH","YBC","YTC"]}');
    ws.send('{"type":"sub","topic":"stockRealtimeByListV2","variables":["AAA","AAM","AAT","ABR","ABS","ABT","ACB","ACC","ACG","ACL","ADG","ADP","ADS","AGG","AGM","AGR","ANV","APC","APG","APH","ASG","ASM","ASP","AST","BAF","BBC","BCE","BCG","BCM","BFC","BHN","BIC","BID","BKG","BMC","BMI","BMP","BRC","BSI","BTP","BTT","BVH","BWE","C32","C47","CAV","CCI","CCL","CDC","CHP","CIG","CII","CKG","CLC","CLL","CLW","CMG","CMV","CMX","CNG","COM","CRC","CRE","CSM","CSV","CTD","CTF","CTG","CTI","CTR","CTS","CVT","D2D","DAG","DAH","DAT","DBC","DBD","DBT","DC4","DCL","DCM","DGC","DGW","DHA","DHC","DHG","DHM","DIG","DLG","DMC","DPG","DPM","DPR","DQC","DRC","DRH","DRL","DSN","DTA","DTL","DTT","DVP","DXG","DXS","DXV","EIB","ELC","EVE","EVF","EVG","FCM","FCN","FDC","FIR","FIT","FMC","FPT","FRT","FTS","GAS","GDT","GEG","GEX","GIL","GMC","GMD","GMH","GSP","GTA","GVR","HAG","HAH","HAP","HAR","HAS","HAX","HBC","HCD","HCM","HDB","HDC","HDG","HHP","HHS","HHV","HID","HII","HMC","HNG","HPG","HPX","HQC","HRC","HSG","HSL","HT1","HTI","HTL","HTN","HTV","HU1","HUB","HVH","HVN","HVX","IBC","ICT","IDI","IJC","ILB","IMP","ITA","ITC","ITD","JVC","KBC","KDC","KDH","KHG","KHP","KMR","KOS","KPF","KSB","L10","LAF","LBM","LCG","LDG","LEC","LGC","LGL","LHG","LIX","LM8","LPB","LSS","MBB","MCP","MDG","MHC","MIG","MSB","MSH","MSN","MWG","NAF","NAV","NBB","NCT","NHA","NHH","NHT","NKG","NLG","NNC","NO1","NSC","NT2","NTL","NVL","NVT","OCB","OGC","OPC","ORS","PAC","PAN","PC1","PDN","PDR","PET","PGC","PGD","PGI","PGV","PHC","PHR","PIT","PJT","PLP","PLX","PMG","PNC","PNJ","POM","POW","PPC","PSH","PTB","PTC","PTL","PVD","PVP","PVT","QBS","QCG","RAL","RDP","REE","S4A","SAB","SAM","SAV","SBA","SBT","SBV","SC5","SCD","SCR","SCS","SFC","SFG","SFI","SGN","SGR","SGT","SHA","SHB","SHI","SHP","SIP","SJD","SJF","SJS","SKG","SMA","SMB","SMC","SPM","SRC","SRF","SSB","SSC","SSI","ST8","STB","STG","STK","SVC","SVD","SVI","SVT","SZC","SZL","TBC","TCB","TCD","TCH","TCL","TCM","TCO","TCR","TCT","TDC","TDG","TDH","TDM","TDP","TDW","TEG","TGG","THG","TIP","TIX","TLD","TLG","TLH","TMP","TMS","TMT","TN1","TNA","TNC","TNH","TNI","TNT","TPB","TPC","TRA","TRC","TSC","TTA","TTB","TTE","TTF","TV2","TVB","TVS","TVT","TYA","UIC","VAF","VCA","VCB","VCF","VCG","VCI","VDP","VDS","VFG","VGC","VHC","VHM","VIB","VIC","VID","VIP","VIX","VJC","VMD","VND","VNE","VNG","VNL","VNM","VNS","VOS","VPB","VPD","VPG","VPH","VPI","VPS","VRC","VRE","VSC","VSH","VSI","VTB","VTO","YBM","YEG","AAV","ADC","ALT","AMC","AME","AMV","API","APS","ARM","ATS","BAB","BAX","BBS","BCC","BCF","BDB","BED","BKC","BLF","BNA","BPC","BSC","BST","BTS","BTW","BVS","BXH","C69","CAG","CAN","CAP","CCR","CDN","CEO","CET","CIA","CJC","CKV","CLH","CLM","CMC","CMS","CPC","CSC","CTB","CTC","CTP","CTT","CTX","CVN","CX8","D11","DAD","DAE","DC2","DDG","DHP","DHT","DIH","DL1","DNC","DNP","DP3","DPC","DS3","DST","DTC","DTD","DTG","DTK","DVG","DVM","DXP","DZM","EBS","ECI","EID","EVS","FID","GDW","GIC","GKM","GLT","GMA","GMX","HAD","HAT","HBS","HCC","HCT","HDA","HEV","HGM","HHC","HJS","HKT","HLC","HLD","HMH","HMR","HOM","HTC","HTP","HUT","HVT","ICG","IDC","IDJ","IDV","INC","INN","IPA","ITQ","IVS","KDM","KHS","KKC","KLF","KMT","KSD","KSF","KSQ","KST","KSV","KTS","KTT","L14","L18","L40","L43","L61","L62","LAS","LBE","LCD","LDP","LHC","LIG","MAC","MAS","MBG","MBS","MCC","MCF","MCO","MDC","MED","MEL","MHL","MIM","MKV","MST","MVB","NAG","NAP","NBC","NBP","NBW","NDN","NDX","NET","NFC","NHC","NRC","NSH","NST","NTH","NTP","NVB","OCH","ONE","PBP","PCE","PCG","PCH","PCT","PDB","PEN","PGN","PGS","PGT","PHN","PIA","PIC","PJC","PLC","PMB","PMC","PMP","PMS","POT","PPE","PPP","PPS","PPT","PPY","PRC","PRE","PSC","PSD","PSE","PSI","PSW","PTD","PTI","PTS","PV2","PVB","PVC","PVG","PVI","PVS","QHD","QST","QTC","RCL","S55","S99","SAF","SCG","SCI","SD5","SD6","SD9","SDA","SDC","SDG","SDN","SDT","SDU","SEB","SED","SFN","SGC","SGD","SGH","SHE","SHN","SHS","SJ1","SJE","SLS","SMN","SMT","SPC","SPI","SRA","SSM","STC","STP","SVN","SZB","TA9","TAR","TBX","TC6","TDN","TDT","TET","TFC","THB","THD","THS","THT","TIG","TJC","TKC","TKG","TKU","TMB","TMC","TMX","TNG","TOT","TPH","TPP","TSB","TTC","TTH","TTL","TTT","TTZ","TV3","TV4","TVC","TVD","TXM","UNI","V12","V21","VBC","VC1","VC2","VC3","VC6","VC7","VC9","VCC","VCM","VCS","VDL","VE1","VE3","VE4","VE8","VFS","VGP","VGS","VHE","VHL","VIF","VIG","VIT","VLA","VMC","VMS","VNC","VNF","VNR","VNT","VSA","VSM","VTC","VTH","VTJ","VTV","VTZ","WCS","WSS","X20","A32","AAS","ABB","ABC","ABI","ABW","ACE","ACM","ACS","ACV","AFX","AG1","AGF","AGP","AGX","AIC","ALV","AMD","AMP","AMS","ANT","APF","APL","APP","APT","ART","ASA","ATA","ATB","ATG","AVC","AVF","B82","BAL","BBH","BBM","BBT","BCA","BCB","BCP","BCV","BDG","BDT","BDW","BEL","BGW","BHA","BHC","BHG","BHI","BHK","BHP","BIG","BII","BIO","BLI","BLN","BLT","BLW","BMD","BMF","BMG","BMJ","BMN","BMS","BMV","BNW","BOT","BQB","BRR","BRS","BSA","BSD","BSG","BSH","BSL","BSP","BSQ","BSR","BT1","BT6","BTB","BTD","BTG","BTH","BTN","BTU","BTV","BVB","BVG","BVL","BVN","BWA","BWS","C12","C21","C22","C4G","C92","CAB","CAD","CAR","CAT","CBI","CBS","CC1","CC4","CCA","CCM","CCP","CCT","CCV","CDG","CDH","CDO","CDP","CDR","CE1","CEG","CEN","CFM","CFV","CGV","CH5","CHC","CHS","CI5","CID","CIP","CK8","CKA","CKD","CLG","CLX","CMD","CMF","CMI","CMK","CMM","CMN","CMP","CMT","CMW","CNA","CNC","CNN","CNT","CPA","CPH","CPI","CQN","CQT","CSI","CST","CT3","CT6","CTA","CTN","CTW","CYC","DAC","DAN","DAS","DBM","DC1","DCF","DCG","DCH","DCR","DCS","DCT","DDH","DDM","DDN","DDV","DFC","DFF","DGT","DHB","DHD","DHN","DIC","DID","DKC","DLD","DLM","DLR","DLT","DM7","DMN","DMS","DNA","DND","DNE","DNH","DNL","DNM","DNN","DNT","DNW","DOC","DOP","DP1","DP2","DPH","DPP","DPS","DRG","DRI","DSC","DSD","DSG","DSP","DSV","DTB","DTE","DTH","DTI","DTP","DTV","DUS","DVC","DVN","DVW","DWC","DWS","DXL","E12","E29","EFI","EIC","EIN","EME","EMG","EMS","EPC","EPH","FBA","FBC","FCC","FCS","FGL","FHN","FHS","FIC","FLC","FOC","FOX","FRC","FRM","FSO","FT1","FTI","FTM","G20","G36","GAB","GCB","GCF","GDA","GEE","GER","GGG","GH3","GHC","GLC","GLW","GND","GPC","GSM","GTD","GTS","GTT","GVT","H11","HAC","HAF","HAI","HAM","HAN","HAV","HBD","HBH","HC1","HC3","HCB","HCI","HD2","HD6","HD8","HDM","HDO","HDP","HDW","HEC","HEJ","HEM","HEP","HES","HFB","HFC","HFX","HGT","HGW","HHG","HHN","HHR","HIG","HJC","HKB","HLA","HLB","HLR","HLS","HLT","HLY","HMG","HMS","HNA","HNB","HND","HNF","HNI","HNM","HNP","HNR","HOT","HPB","HPD","HPH","HPI","HPM","HPP","HPT","HPW","HRB","HRT","HSA","HSI","HSM","HSP","HSV","HTE","HTG","HTM","HTT","HU3","HU4","HU6","HUG","HVA","HVG","HWS","IBD","ICC","ICF","ICI","ICN","IDP","IFS","IHK","ILA","ILC","ILS","IME","IN4","IRC","ISG","ISH","IST","ITS","JOS","KAC","KCB","KCE","KGM","KHD","KHL","KHW","KIP","KLB","KLM","KSH","KTC","KTL","KVC","L12","L35","L44","L45","L63","LAI","LAW","LBC","LCC","LCM","LCS","LDW","LG9","LGM","LIC","LKW","LLM","LM3","LM7","LMC","LMH","LMI","LNC","LO5","LPT","LQN","LSG","LTC","LTG","LUT","M10","MA1","MBN","MCD","MCG","MCH","MCM","MDA","MDF","MEC","MEF","MES","MFS","MGC","MGG","MGR","MH3","MIC","MIE","MKP","MLC","MLS","MML","MNB","MND","MPC","MPT","MPY","MQB","MQN","MRF","MSR","MTA","MTB","MTC","MTG","MTH","MTL","MTP","MTS","MTV","MVC","MVN","NAB","NAC","NAS","NAU","NAW","NBE","NBT","NCS","ND2","NDC","NDF","NDP","NDT","NDW","NED","NGC","NHP","NHV","NJC","NLS","NNT","NOS","NQB","NQN","NQT","NS2","NSG","NSL","NSS","NTB","NTC","NTF","NTT","NTW","NUE","NVP","NWT","NXT","ODE","OIL","ONW","PAI","PAP","PAS","PAT","PBC","PBT","PCC","PCF","PCM","PCN","PDC","PDV","PEC","PEG","PEQ","PFL","PGB","PHH","PHP","PHS","PID","PIS","PIV","PJS","PLA","PLE","PLO","PMJ","PMT","PMW","PND","PNG","PNP","PNT","POB","POS","POV","PPH","PPI","PQN","PRO","PRT","PSB","PSG","PSL","PSN","PSP","PTE","PTG","PTH","PTN","PTO","PTP","PTT","PTV","PTX","PVA","PVE","PVH","PVL","PVM","PVO","PVR","PVV","PVX","PVY","PWA","PWS","PX1","PXA","PXC","PXI","PXL","PXM","PXS","PXT","QCC","QHW","QNC","QNS","QNT","QNU","QNW","QPH","QSP","QTP","RAT","RBC","RCC","RCD","RGC","RIC","RTB","S12","S27","S72","S74","S96","SAC","SAL","SAP","SAS","SB1","SBD","SBH","SBL","SBM","SBR","SBS","SCC","SCJ","SCL","SCO","SCY","SD1","SD2","SD3","SD4","SD7","SD8","SDB","SDD","SDJ","SDK","SDP","SDV","SDX","SDY","SEA","SEP","SGB","SGI","SGO","SGP","SGS","SHC","SHG","SHX","SID","SIG","SII","SIV","SJC","SJG","SJM","SKH","SKN","SKV","SNC","SNZ","SP2","SPB","SPD","SPH","SPV","SQC","SRB","SRT","SSF","SSG","SSH","SSN","STH","STL","STS","STT","STW","SVG","SVH","SWC","SZE","SZG","TA3","TA6","TAN","TAW","TB8","TBD","TBH","TBR","TBT","TCI","TCJ","TCK","TCW","TDB","TDF","TDS","TED","TEL","TGP","TH1","THN","THP","THU","THW","TID","TIE","TIN","TIS","TKA","TL4","TLI","TLP","TLT","TMG","TMW","TNB","TNM","TNP","TNS","TNW","TOP","TOS","TOW","TPS","TQN","TQW","TR1","TRS","TRT","TS3","TS4","TSD","TSG","TSJ","TST","TTD","TTG","TTN","TTP","TTS","TUG","TV1","TV6","TVA","TVG","TVH","TVM","TVN","TVP","TW3","UCT","UDC","UDJ","UDL","UEM","UMC","UPC","UPH","USC","USD","V11","V15","VAB","VAV","VBB","VBG","VBH","VC5","VCE","VCP","VCR","VCT","VCW","VCX","VDB","VDN","VDT","VE2","VE9","VEA","VEC","VEF","VES","VET","VFC","VFR","VGG","VGI","VGL","VGR","VGT","VGV","VHD","VHF","VHG","VHH","VIE","VIH","VIM","VIN","VIR","VIW","VKC","VKP","VLB","VLC","VLF","VLG","VLP","VLW","VMA","VMG","VMT","VNA","VNB","VNH","VNI","VNP","VNX","VNY","VNZ","VOC","VPA","VPC","VPR","VPW","VQC","VRG","VSE","VSF","VSG","VSN","VST","VTA","VTD","VTE","VTG","VTI","VTK","VTL","VTM","VTP","VTQ","VTR","VTS","VTX","VUA","VVN","VVS","VW3","VWS","VXB","VXP","VXT","WSB","WTC","X26","X77","XDC","XDH","XHC","XLV","XMC","XMD","XMP","XPH","YBC","YTC"],"component":"depthChart"}');
    ws.send('{"type":"sub","topic":"notifyIndexRealtimeByListV2","variables":["VNINDEX","VN30","HNX30","HNXIndex","VNXALL","HNXUpcomIndex"]}')

    let vn30fa = getPairVN30Feature().join()
    ws.send('{"type":"sub","topic":"stockRealtimeByListV2","variables":['+vn30fa+'],"component":"depthChart"}')
    ws.send('{"type":"sub","topic":"matchedVolByPriceV2","variables":['+vn30fa+']}')
    ws.send('{"type":"sub","topic":"leTableAddV2","variables":['+vn30fa+']}')

    setInterval(() => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send('{"type":"init"}');
        // ws.send('{"type":"sub","topic":"stockRealtimeByList","variables":["hose:21","hose:9","hose:702","hose:4413","hose:234","hose:3","hose:436","hose:15","hose:4619","hose:4","hose:682","hose:4787","hose:19","hose:156","hose:17","hose:10","hose:5","hose:13","hose:22","hose:307","hose:354","hose:12","hose:7","hose:24","hose:4356","hose:190","hose:212","hose:218","hose:338","hose:219","hose:220","hose:215","hose:217","hose:447","hose:199","hose:206","hose:195","hose:216","hose:214","hose:210","hose:211","hose:209","hose:221","hose:598","hose:593","hose:601","hose:586","hose:592","hose:589","hose:604","hose:595","hose:572","hose:236","hose:575","hose:599","hose:591","hose:583","hose:587","hose:590","hose:596","hose:574","hose:46","hose:48","hose:581","hose:603","hose:582","hose:606","hose:580","hose:585","hose:4402","hose:607","hose:608","hose:642","hose:647","hose:658","hose:657","hose:101","hose:33","hose:397","hose:370","hose:640","hose:655","hose:308","hose:656","hose:622","hose:641","hose:629","hose:654","hose:643","hose:649","hose:631","hose:30","hose:634","hose:635","hose:637","hose:633","hose:651","hose:653","hose:652","hose:650","hose:648","hose:630","hose:644","hose:646","hose:3982","hose:638","hose:792","hose:793","hose:794","hose:4382","hose:797","hose:979","hose:978","hose:976","hose:53","hose:981","hose:973","hose:974","hose:26","hose:983","hose:4281","hose:4609","hose:985","hose:1152","hose:1149","hose:108","hose:1154","hose:1145","hose:1147","hose:1146","hose:4383","hose:1151","hose:1148","hose:233","hose:1364","hose:1380","hose:1291","hose:1379","hose:1292","hose:1337","hose:1339","hose:1382","hose:1366","hose:1386","hose:1348","hose:1369","hose:685","hose:1378","hose:4396","hose:1383","hose:1384","hose:1336","hose:1381","hose:1354","hose:41","hose:1372","hose:1338","hose:1363","hose:28","hose:1351","hose:1373","hose:1374","hose:58","hose:1318","hose:1377","hose:68","hose:60","hose:69","hose:1371","hose:1422","hose:163","hose:1420","hose:1419","hose:70","hose:1416","hose:1415","hose:1418","hose:1421","hose:1604","hose:1731","hose:1727","hose:1734","hose:3984","hose:1728","hose:1729","hose:100","hose:1738","hose:1733","hose:1891","hose:1888","hose:1889","hose:1893","hose:1899","hose:1900","hose:1890","hose:1894","hose:1896","hose:1895","hose:1897","hose:416","hose:1892","hose:2027","hose:2019","hose:2026","hose:2017","hose:666","hose:443","hose:59","hose:2024","hose:2028","hose:2199","hose:2186","hose:2188","hose:2197","hose:667","hose:145","hose:4321","hose:2195","hose:2196","hose:2193","hose:4639","hose:2185","hose:2198","hose:2187","hose:2200","hose:2191","hose:670","hose:2340","hose:2339","hose:4301","hose:2549","hose:2570","hose:2575","hose:2573","hose:2567","hose:2552","hose:2546","hose:2560","hose:2572","hose:4401","hose:50","hose:2558","hose:2554","hose:2550","hose:2577","hose:2576","hose:2579","hose:2545","hose:2557","hose:2562","hose:66","hose:2551","hose:288","hose:2571","hose:2556","hose:2568","hose:2548","hose:4662","hose:2553","hose:2698","hose:2697","hose:2737","hose:2739","hose:2735","hose:2944","hose:2947","hose:2902","hose:2904","hose:2932","hose:2923","hose:2948","hose:2919","hose:2914","hose:2945","hose:43","hose:2905","hose:2942","hose:2918","hose:42","hose:2950","hose:2922","hose:2946","hose:4126","hose:2928","hose:2941","hose:4802","hose:2912","hose:2949","hose:2907","hose:2940","hose:2935","hose:44","hose:2911","hose:2931","hose:2926","hose:2927","hose:703","hose:2906","hose:2920","hose:2921","hose:2908","hose:2930","hose:2943","hose:2925","hose:671","hose:2938","hose:2937","hose:67","hose:2924","hose:3489","hose:32","hose:3507","hose:3506","hose:3492","hose:3483","hose:3502","hose:3479","hose:3504","hose:3496","hose:3510","hose:3476","hose:55","hose:367","hose:3499","hose:3514","hose:31","hose:3501","hose:3505","hose:3490","hose:3512","hose:3495","hose:3494","hose:3487","hose:3275","hose:3493","hose:73","hose:3362","hose:3481","hose:612","hose:3508","hose:3497","hose:25","hose:3484","hose:3486","hose:3480","hose:3482","hose:348","hose:45","hose:61","hose:3485","hose:74","hose:36","hose:3503","hose:3511","hose:3434","hose:3637","hose:3841","hose:701","hose:3825","hose:3840","hose:446","hose:3849","hose:3851","hose:3850","hose:3830","hose:72","hose:3815","hose:29","hose:417","hose:3813","hose:3808","hose:3807","hose:613","hose:3847","hose:3837","hose:3853","hose:3812","hose:3829","hose:3826","hose:3801","hose:3821","hose:3835","hose:3852","hose:3858","hose:3857","hose:3827","hose:37","hose:3842","hose:3833","hose:3854","hose:3816","hose:3802","hose:3839","hose:3810","hose:3814","hose:47","hose:34"]}');
      }
    }, 30000);
  });

  ws.on('message', function (message) {
    listModel.forEach(md => {
      md.onMessage(message)
    })

  });

  ws.on('close', function () {
    console.log('WebSocket connection closed');
    wss()
  });

  ws.on('error', function (error) {
    console.log(`WebSocket error: ${error}`);
  });

}

if (!fs.existsSync("../websocket/")) {
  fs.mkdirSync("../websocket/")
}

wss();

function getNow() {
  let fd = new Date(Date.now());
  return fd.getFullYear()
    + "" + (fd.getMonth() + 1 < 10 ? "0" + (fd.getMonth() + 1) : fd.getMonth() + 1)
    + "" + (fd.getDate() < 10 ? "0" + fd.getDate() : fd.getDate());
}

class Model {
  onMessage(message) { }
}

let pendingModel = { hose: {}, hnx: {}, upcom: {} }
class PendingModel extends Model {
  onMessage(messageBuff) {
    const message = messageBuff.toString('utf-8');
    if (message.includes("S#")) {
      let messageText = message;
      let symbols = messageText.slice(2, 5)
      // if (stock[symbols] == "hose") {
      // console.log(messageText.slice(2,5),`Received message: ${messageText}`);
      priceModel.onMessage(messageText)
      // }
    } else if (message.includes("I#VNINDEX")) {
      let messageText = message;
      // console.log(messageText.slice(2, 5), `Received message: ${messageText}`);
      priceModel.onIndex(messageText)

    } else if (message.includes("L#")) {
      let messageText = message;
      // console.log(messageText.slice(2, 5), `Received message: ${messageText}`);
      priceModel.onLetable(messageText)

    } else if (message.includes("M#")) {
      let messageText = message;
      // console.log(messageText.slice(2, 5), `Received message: ${messageText}`);
      priceModel.onMatched(messageText)
    }
  }
}

class MessageWriter extends Model {
  onMessage(message) {

    // fs.appendFile("../websocket/data_pending_2_" + getNow() + ".txt", Date.now() + "|" + message + '\n', (e) => {
    //   if (e) console.log(e)
    // })
  }
}

let lastReadTime = 0;

class MessageReader extends Model {
  async reader() {

    // let data = fs.readFileSync("../websocket/data3" + getNow() + ".txt", "utf-8")
    // console.log('Data ',data.length)
    let filename = "../websocket/data3" + getNow() + ".txt";
    // let filename = "../websocket/data320231122.txt";
    let stats = fs.statSync(filename);
    if (stats.size < 3 * 128 * 1024 * 1024) {
      let data = fs.readFileSync(filename, { encoding: 'utf8', flag: 'r', bufferSize: 1024 * 1024 * 128 })
      let messages = data.split('\n');
      let stat = { req: 0, res: 0, total: messages.length }
      messages.forEach(m => {
        stat.req++;
        this.onMessage(m)
        stat.res++;
        if (stat.req % 10000 == 0) {
          console.log(stat, priceModel.data.length, priceModel.dataC)
        }
      })
    } else {
      let readStream = fs.createReadStream(filename, {
        encoding: 'utf8',
        highWaterMark: 128 * 1024 * 1024, // 128 MB
      })
      // Handle data events      
      let remainingData = ''
      let stat = { req: 0, res: 0, total: 0 }
      readStream.on('data', (chunk) => {
        remainingData += chunk;
        const lastNewlineIndex = remainingData.lastIndexOf('\n');
        // If a newline character is found, process the data before the last newline
        if (lastNewlineIndex !== -1) {
          const dataBeforeLastNewline = remainingData.substring(0, lastNewlineIndex);
          // console.log(dataBeforeLastNewline)         
          remainingData = remainingData.substring(lastNewlineIndex + 1);
          let messages = dataBeforeLastNewline.split('\n');
          stat.total += messages.length;
          messages.forEach(m => {
            stat.req++;
            this.onMessage(m)
            stat.res++;
            if (stat.req % 10000 == 0) {
              console.log(stat, priceModel.data.length, priceModel.dataC)
            }
          })
        }
      });

      // Handle end event
      readStream.on('end', () => {
        console.log('Finished reading the file.');
      });

      // Handle error events
      readStream.on('error', (error) => {
        console.error('Error reading the file:', error);
      });
    }
    console.log("Write log")
  }

  async onMessage(message) {
    if (message.includes("S#")) {
      let messageText = message.slice(message.indexOf("|") + 1)
      lastReadTime = message.slice(0, message.indexOf("|"))
      // console.log(lastReadTime)
      let symbols = messageText.slice(2, 5)
      // if (stock[symbols] == "hose") {
      // console.log(messageText.slice(2,5),`Received message: ${messageText}`);
      priceModel.onMessage(messageText)

      // }
    } else if (message.includes("I#VNINDEX")) {
      let messageText = message.slice(message.indexOf("|") + 1)
      // console.log(messageText.slice(2, 5), `Received message: ${messageText}`);
      priceModel.onIndex(messageText)

    } else if (message.includes("L#")) {
      let messageText = message.slice(message.indexOf("|") + 1)
      // console.log(messageText.slice(2, 5), `Received message: ${messageText}`);
      priceModel.onLetable(messageText)

    } else if (message.includes("M#")) {
      let messageText = message.slice(message.indexOf("|") + 1)
      // console.log(messageText.slice(2, 5), `Received message: ${messageText}`);
      priceModel.onMatched(messageText)

    }
  }
}



let listModel = [new PendingModel(), new MessageWriter()]

let sum = (a) => {
  let T = { vol: 0, val: 0 }
  Object.keys(a).forEach(k => {
    T.val += +k * a[k]
    T.vol += a[k]
  })
  return T;
}

class PriceModel {
  board = {}
  stat = {}
  BIDASK = { bid: { vol: 0, val: 0 }, ask: { vol: 0, val: 0 } }
  IndexBIDASK = {}
  data = [];
  lastDataLength = 0
  lastData = []
  mapLastData = {}
  dataC = 0;
  last = Date.now()
  async onMessage(message) {
    let a = message.split("|")
    let symbol = a[0].slice(2)
    // if(message.includes("SHS")) console.log("Count ", this.count(a), message)
    // console.log("Count ", this.count(a), message)
    if (this.count(a) >= 32) {
      let old = null;
      if (!this.board[symbol])
        this.board[symbol] = { BID: {}, ASK: {} }
      else {
        old = this.board[symbol];
        this.board[symbol] = { BID: {}, ASK: {} }
      }


      for (let i = 1; i <= 20; i += 2) {
        if (a[i].length > 0 && (!Number.isNaN(+a[i]) || !Number.isNaN(+a[i + 1]))) this.board[symbol].BID[+a[i]] = +a[i + 1]
        else if (a[i].length > 0) console.table(a)
      }
      for (let i = 21; i <= 40; i += 2) {
        if (a[i].length > 0 && (!Number.isNaN(+a[i]) || !Number.isNaN(+a[i + 1]))) this.board[symbol].ASK[+a[i]] = +a[i + 1]
        // else if(a[i].length > 0) console.table(a)
      }
      // console.table(a)
      // console.table(this.board[symbol].BID)
      // console.table(this.board[symbol].ASK)

      let b = this.board;


      let sectorCode = '0000', sectorName = 'OtherSector'
      // if (stockStore[symbol]) sectorName = stockStore[symbol].SectorName;
      if (map20[symbol]) { sectorCode = map20[symbol].industryCode; sectorName = map20[symbol].vietnameseName }
      // else
      // console.log(symbol)

      let index = '';
      if (stock[symbol] == "hose") index = 'VNINDEX'
      else {
        if (stock[symbol])
          index = stock[symbol].toUpperCase()
        else {
          index = 'OtherIDX'
          // console.log('Other Symbol', symbol)
        }
      }


      //find diff
      let diff = { bid: { vol: 0, val: 0 }, ask: { vol: 0, val: 0 } }
      if (!old) {
        let b = this.board[symbol]
        let T = sum(b.BID)
        // console.table(T)
        diff.bid.vol += T.vol
        diff.bid.val += T.val
        T = sum(b.ASK)
        // console.table(T)
        diff.ask.vol += T.vol
        diff.ask.val += T.val

      }
      else {
        let b = this.board[symbol]
        let T = sum(b.BID)
        diff.bid.vol += T.vol
        diff.bid.val += T.val
        T = sum(b.ASK)
        diff.ask.vol += T.vol
        diff.ask.val += T.val
        b = old;
        T = sum(b.BID)
        diff.bid.vol -= T.vol
        diff.bid.val -= T.val
        T = sum(b.ASK)
        diff.ask.vol -= T.vol
        diff.ask.val -= T.val
      }

      if (symbol.startsWith('VN30F')) {
        return;
      }
      let ALL = 'ALL'
      let symbolCap = mapCap[symbol]
      if (!mapCap[symbol]) symbolCap = 'MIDDLE'
      let A = [ALL, sectorCode, symbolCap]
      A.forEach(code => {
        if (!this.BIDASK[code]) this.BIDASK[code] = { bid: { vol: 0, val: 0 }, ask: { vol: 0, val: 0 } }
        if (!Number.isNaN(diff.bid.vol))
          this.BIDASK[code].bid.vol += diff.bid.vol
        if (!Number.isNaN(diff.bid.val))
          this.BIDASK[code].bid.val += diff.bid.val
        if (!Number.isNaN(diff.ask.vol))
          this.BIDASK[code].ask.vol += diff.ask.vol
        if (!Number.isNaN(diff.ask.val))
          this.BIDASK[code].ask.val += diff.ask.val
        // console.log(code)
        // console.table(this.BIDASK[code])
      })





      if (!this.IndexBIDASK[index]) this.IndexBIDASK[index] = { bid: { vol: 0, val: 0 }, ask: { vol: 0, val: 0 } }
      if (!Number.isNaN(diff.bid.vol))
        this.IndexBIDASK[index].bid.vol += diff.bid.vol
      if (!Number.isNaN(diff.bid.val))
        this.IndexBIDASK[index].bid.val += diff.bid.val
      if (!Number.isNaN(diff.ask.vol))
        this.IndexBIDASK[index].ask.vol += diff.ask.vol
      if (!Number.isNaN(diff.ask.val))
        this.IndexBIDASK[index].ask.val += diff.ask.val

      if (stock[symbol] != "hose") {
        return;
      } else {

        if (!Number.isNaN(diff.bid.vol))
          this.BIDASK.bid.vol += diff.bid.vol
        if (!Number.isNaN(diff.bid.val))
          this.BIDASK.bid.val += diff.bid.val
        if (!Number.isNaN(diff.ask.vol))
          this.BIDASK.ask.vol += diff.ask.vol
        if (!Number.isNaN(diff.ask.val))
          this.BIDASK.ask.val += diff.ask.val


        let vni = {
          "VNINDEX": this.BIDASK["VNINDEX"], "time": this.BIDASK["time"], "date": this.BIDASK["date"],
          "bid_vol": this.BIDASK["bid"].vol,
          "bid_val": this.BIDASK["bid"].val,
          "ask_vol": this.BIDASK["ask"].vol,
          "ask_val": this.BIDASK["ask"].val,
        }

        if (this.stat["VNINDEX"] && this.stat["VNINDEX"].bu && this.stat["VNINDEX"].sd) {
          vni = {
            ...vni,
            "bu_vol": this.stat["VNINDEX"].bu.vol,
            "bu_val": this.stat["VNINDEX"].bu.val,
            "sd_vol": this.stat["VNINDEX"].sd.vol,
            "sd_val": this.stat["VNINDEX"].sd.val,
            "uk_vol": this.stat["VNINDEX"].unknown.vol,
            "uk_val": this.stat["VNINDEX"].unknown.val,
            "busd_vol": this.stat["VNINDEX"].bu.vol - this.stat["VNINDEX"].sd.vol,
            "busd_val": this.stat["VNINDEX"].bu.val - this.stat["VNINDEX"].sd.val,
          }

          if (!this.stat["VNINDEX"]["min_busd_val"] || this.stat["VNINDEX"]["min_busd_val"] > vni["busd_val"]) this.stat["VNINDEX"]["min_busd_val"] = vni["busd_val"]
          if (!this.stat["VNINDEX"]["max_busd_val"] || this.stat["VNINDEX"]["max_busd_val"] < vni["busd_val"]) this.stat["VNINDEX"]["max_busd_val"] = vni["busd_val"]
          vni["min_busd_val"] = this.stat["VNINDEX"]["min_busd_val"]
          vni["max_busd_val"] = this.stat["VNINDEX"]["max_busd_val"]
        }

        this.data[this.dataC++] = vni
        if (this.dataC % 100 == 0 || Date.now() - this.last > 1000) {
          // console.table(vni)
          this.last = Date.now()
        }

      }



    }
  }


  async onIndex(message) {
    let a = message.split("|")
    let symbol = a[0].slice(2)
    this.BIDASK[symbol] = +a[1]
    // const dynamicData = {
    //   labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
    //   data: Array(6).fill().map(() => Math.floor(Math.random() * 20)),
    // };
    // dynamicData.data[0] = this.BIDASK["VNINDEX"]

    // parentPort.postMessage(dynamicData);

    this.BIDASK["time"] = +a[13]
    let format = moment(+a[13]).format("HH:mm:ss")
    this.BIDASK["date"] = format
  }

  async onLetable(message) {
    let a = message.split("|")
    let symbol = a[0].slice(2)
    // console.log(message)
    let [price, vol, total, time, priceref, slide, change, pct, trend] = [...a.slice(1)];
    [price, vol, total, priceref, change, pct] = [price, vol, total, priceref, change, pct].map(e => +e);

    let format = "HH:mm:ss"
    time = moment(time, format).format("HH:mm")
    let timeX = moment(time, "HH:mm").format("X")
    let sectorCode = '0000', sectorName = 'OtherSector'
    // if (stockStore[symbol]) sectorName = stockStore[symbol].SectorName;
    if (map20[symbol]) { sectorCode = map20[symbol].industryCode; sectorName = map20[symbol].vietnameseName }
    // console.log("TimeX", timeX)

    let index = '';
    if (stock[symbol] == "hose") index = 'VNINDEX'
    else {
      if (stock[symbol])
        index = stock[symbol].toUpperCase()
      else {
        index = 'OtherIDX'
      }
    }

    let ALL = 'ALL';
    let symbolCap = mapCap[symbol]
    if (!mapCap[symbol]) symbolCap = 'MIDDLE'

    if (!this.stat[symbol]) this.stat[symbol] = { unknown: { vol: 0, val: 0 }, open: price, close: price, high: price, low: price }
    if (!this.stat[symbol].T) this.stat[symbol].T = {}
    if (!this.stat[symbol].T[time]) this.stat[symbol].T[time] = { VNINDEX: this.BIDASK["VNINDEX"], time: time, T: timeX, unknown: { vol: 0, val: 0 }, open: price, close: price, high: price, low: price }
    let A = [index, ALL, sectorCode, symbolCap]
    A.forEach(code => {
      if (!this.stat[code]) this.stat[code] = { unknown: { vol: 0, val: 0 } }
      if (!this.stat[code].T) this.stat[code].T = {}
      if (!this.stat[code].T[time]) this.stat[code].T[time] = { VNINDEX: this.BIDASK["VNINDEX"], time: time, T: timeX, unknown: { vol: 0, val: 0 } }
    })
    // if (!this.stat[index]) this.stat[index] = { unknown: { vol: 0, val: 0 } }
    // if (!this.stat[index].T) this.stat[index].T = {}
    // if (!this.stat[index].T[time]) this.stat[index].T[time] = { VNINDEX: this.BIDASK["VNINDEX"], time: time, T: timeX, unknown: { vol: 0, val: 0 } }

    // if (!this.stat["ALL"]) this.stat["ALL"] = { unknown: { vol: 0, val: 0 } }
    // if (!this.stat["ALL"].T) this.stat["ALL"].T = {}
    // if (!this.stat["ALL"].T[time]) this.stat["ALL"].T[time] = { VNINDEX: this.BIDASK["VNINDEX"], time: time, T: timeX, unknown: { vol: 0, val: 0 } }

    // if (!this.stat[sectorCode]) this.stat[sectorCode] = { unknown: { vol: 0, val: 0 } }
    // if (!this.stat[sectorCode].T) this.stat[sectorCode].T = {}
    // if (!this.stat[sectorCode].T[time]) this.stat[sectorCode].T[time] = { VNINDEX: this.BIDASK["VNINDEX"], time: time, T: timeX, unknown: { vol: 0, val: 0 } }


    let all = this.stat["ALL"];
    let v = this.stat[index];
    let vt = this.stat[index].T[time];
    let b = this.stat[symbol];
    let bt = this.stat[symbol].T[time];
    let allt = this.stat["ALL"].T[time];
    let s = this.stat[sectorCode]
    let st = this.stat[sectorCode].T[time];
    let g = this.stat[symbolCap]
    let gt = this.stat[symbolCap].T[time];

    // let fa = stock[symbol] == "hose" ? [b, v, all, bt, vt, allt, s, st] : [b, all, bt, allt, s, st]
    let fa;
    if (symbol.startsWith('VN30F')) {
      fa = [b, bt]
    } else {
      fa = [b, v, all, bt, vt, allt, s, st, g, gt]
    }

    fa.forEach(e => {
      if (!e[slide]) {
        e[slide] = { vol: 0, val: 0 }
      } else {
        e[slide].vol += vol
        e[slide].val += vol * price
      }
    });


    //Xu ly BT
    ([b, bt]).forEach(e => {
      e.close = price;
      if (e.high < price) e.high = price
      if (e.low > price) e.low = price
    });


    // console.table(b)
    if (stock[symbol] == "hose") {
      vt.VNINDEX = this.BIDASK["VNINDEX"]
      vt["bid_vol"] = this.BIDASK["bid"].vol
      vt["bid_val"] = this.BIDASK["bid"].val
      vt["ask_vol"] = this.BIDASK["ask"].vol
      vt["ask_val"] = this.BIDASK["ask"].val
      if (!this.mapLastData[time]) {
        this.mapLastData[time] = vt;
        this.lastData.push(vt)
        let keep = 1000
        if (this.lastData.length > keep) {
          for (let i = 0; i < this.lastData.length - keep; i++) {
            delete this.mapLastData[this.lastData[i].time]
          }
          this.lastData = this.lastData.slice(this.lastData.length - keep)
        }
      }
    } else {
      // vt[index] = this.BIDASK[index]
      // vt["bid_vol"] = this.BIDASK[index]["bid"].vol
      // vt["bid_val"] = this.BIDASK[index]["bid"].val
      // vt["ask_vol"] = this.BIDASK[index]["ask"].vol
      // vt["ask_val"] = this.BIDASK[index]["ask"].val
    }


    let cp = {}
    Object.keys(b).filter(k => k != 'T').forEach(k => {
      cp[k] = b[k]
    })
    let cpt = {}
    Object.keys(bt).filter(k => k != 'T').forEach(k => {
      cpt[k] = bt[k]
    })

    // if(symbol == 'HPG')
    // console.table(cp)

    let stats = { symbol: symbol, time: time, T: timeX, price: price, priceref: priceref, change: change, pct: pct, ...flattenObject(cp) }
    let stats2 = { symbol: symbol, time: time, T: timeX, price: price, priceref: priceref, change: change, pct: pct, ...flattenObject(cpt) }



    if (!symbol.startsWith('VN30F')) {
      let ip = {}
      Object.keys(v).filter(k => k != 'T').forEach(k => {
        ip[k] = v[k]
      })
      let ipt = {}
      Object.keys(vt).filter(k => k != 'T').forEach(k => {
        ipt[k] = vt[k]
      })
      let indexStats = {
        code: index, name: index, time: time, T: timeX, ...flattenObject(ip)
      }

      let indexStatsDetail = {
        code: index, name: index, time: time, T: timeX, ...flattenObject(ipt)
      }
      if (this.IndexBIDASK[index]) {
        indexStats.bid_vol = this.IndexBIDASK[index]["bid"].vol
        indexStats.bid_val = this.IndexBIDASK[index]["bid"].val
        indexStats.ask_vol = this.IndexBIDASK[index]["ask"].vol
        indexStats.ask_val = this.IndexBIDASK[index]["ask"].val

        indexStatsDetail.bid_vol = this.IndexBIDASK[index]["bid"].vol
        indexStatsDetail.bid_val = this.IndexBIDASK[index]["bid"].val
        indexStatsDetail.ask_vol = this.IndexBIDASK[index]["ask"].vol
        indexStatsDetail.ask_val = this.IndexBIDASK[index]["ask"].val
      }



      let ap = {}
      Object.keys(all).filter(k => k != 'T').forEach(k => {
        ip[k] = all[k]
      })
      let apt = {}
      Object.keys(allt).filter(k => k != 'T').forEach(k => {
        ipt[k] = allt[k]
      })
      let allStats = {
        code: 'ALL', name: 'ALL', time: time, T: timeX, ...flattenObject(ip)
      }

      let allStatsDetail = {
        code: 'ALL', name: 'ALL', time: time, T: timeX, ...flattenObject(ipt)
      }

      if (this.BIDASK[ALL]) {
        allStats.bid_vol = this.BIDASK[ALL]["bid"].vol
        allStats.bid_val = this.BIDASK[ALL]["bid"].val
        allStats.ask_vol = this.BIDASK[ALL]["ask"].vol
        allStats.ask_val = this.BIDASK[ALL]["ask"].val

        allStatsDetail.bid_vol = this.BIDASK[ALL]["bid"].vol
        allStatsDetail.bid_val = this.BIDASK[ALL]["bid"].val
        allStatsDetail.ask_vol = this.BIDASK[ALL]["ask"].vol
        allStatsDetail.ask_val = this.BIDASK[ALL]["ask"].val
      }


      let gp = {}
      Object.keys(g).filter(k => k != 'T').forEach(k => {
        ip[k] = g[k]
      })
      let gpt = {}
      Object.keys(gt).filter(k => k != 'T').forEach(k => {
        ipt[k] = allt[k]
      })
      let groupStats = {
        code: symbolCap, name: symbolCap, time: time, T: timeX, ...flattenObject(ip)
      }

      let groupStatsDetail = {
        code: symbolCap, name: symbolCap, time: time, T: timeX, ...flattenObject(ipt)
      }

      if (this.BIDASK[symbolCap]) {
        groupStats.bid_vol = this.BIDASK[symbolCap]["bid"].vol
        groupStats.bid_val = this.BIDASK[symbolCap]["bid"].val
        groupStats.ask_vol = this.BIDASK[symbolCap]["ask"].vol
        groupStats.ask_val = this.BIDASK[symbolCap]["ask"].val
        groupStatsDetail.bid_vol = this.BIDASK[symbolCap]["bid"].vol
        groupStatsDetail.bid_val = this.BIDASK[symbolCap]["bid"].val
        groupStatsDetail.ask_vol = this.BIDASK[symbolCap]["ask"].vol
        groupStatsDetail.ask_val = this.BIDASK[symbolCap]["ask"].val
      }

      let sp = {}
      Object.keys(s).filter(k => k != 'T').forEach(k => {
        sp[k] = s[k]
      })
      let spt = {}
      Object.keys(st).filter(k => k != 'T').forEach(k => {
        spt[k] = st[k]
      })
      let sectorStats = {
        code: sectorCode, name: sectorName, time: time, T: timeX, ...flattenObject(sp)
      }

      let sectorStatsDetail = {
        code: sectorCode, name: sectorName, time: time, T: timeX, ...flattenObject(spt)
      }
      if (this.BIDASK[sectorCode]) {
        sectorStats.bid_vol = this.BIDASK[sectorCode]["bid"].vol
        sectorStats.bid_val = this.BIDASK[sectorCode]["bid"].val
        sectorStats.ask_vol = this.BIDASK[sectorCode]["ask"].vol
        sectorStats.ask_val = this.BIDASK[sectorCode]["ask"].val

        sectorStatsDetail.bid_vol = this.BIDASK[sectorCode]["bid"].vol
        sectorStatsDetail.bid_val = this.BIDASK[sectorCode]["bid"].val
        sectorStatsDetail.ask_vol = this.BIDASK[sectorCode]["ask"].vol
        sectorStatsDetail.ask_val = this.BIDASK[sectorCode]["ask"].val
      }

      if (parentPort) {
        parentPort.postMessage({ data: sectorStatsDetail, dataacum: sectorStats, type: '3' });
        parentPort.postMessage({ data: indexStatsDetail, dataacum: indexStats, type: '4' });
        parentPort.postMessage({ data: allStatsDetail, dataacum: allStats, type: '4' });
        parentPort.postMessage({ data: groupStatsDetail, dataacum: groupStats, type: '4' });
      }
    }
    if (this.board[symbol]) {
      let bid = sum(this.board[symbol].BID)
      let ask = sum(this.board[symbol].ASK)
      stats.bid_vol = bid.vol
      stats.bid_val = bid.val
      stats.ask_vol = ask.vol
      stats.ask_val = ask.val
      stats2.bid_vol = bid.vol
      stats2.bid_val = bid.val
      stats2.ask_vol = ask.vol
      stats2.ask_val = ask.val
    }

    if (stats.bu_vol && stats.sd_vol) {
      stats.busd_vol = stats.bu_vol - stats.sd_vol
      stats.busd_val = stats.bu_val - stats.sd_val
    }

    if (stats2.bu_vol && stats2.sd_vol) {
      stats2.busd_vol = stats2.bu_vol - stats2.sd_vol
      stats2.busd_val = stats2.bu_val - stats2.sd_val
    }

    // if(symbol == 'HPG')
    //   console.table(stats)
    let table = {
      // labels: ["symbol", "time", "T", "bid_vol", "bid_val", "ask_vol", "ask_val", "bu_vol", "bu_val", "sd_vol", "sd_val", "uk_vol", "uk_val", "busd_vol", "busd_val",],
      data: ["symbol", "time", "T", "price", "change", "pct", "bid_vol", "bid_val", "ask_vol", "ask_val", "bu_vol", "bu_val", "sd_vol", "sd_val", "unknown_vol", "unknown_val", "busd_vol", "busd_val",].map(e =>
        stats[e]
      )
    }



    // console.table(table)
    if (parentPort) {
      parentPort.postMessage({ data: table, type: '1' });
      parentPort.postMessage({ data: stats2, dataacum: stats, type: '2' });
      // parentPort.postMessage({ data: sectorStatsDetail, dataacum: sectorStats, type: '3' });
      // parentPort.postMessage({ data: indexStatsDetail, dataacum: indexStats, type: '4' });
      // parentPort.postMessage({ data: allStatsDetail, dataacum: allStats, type: '4' });
      // parentPort.postMessage({ data: groupStatsDetail, dataacum: groupStats, type: '4' });
    }



    if (this.dataC % 100 == 0 || Date.now() - this.last > 1000) {
      this.onPostMessage()
    }
  }

  async intervalCheck() {
    if (this.lastDataLength < this.lastData.length && (Date.now() - this.last > 1000)) {
      this.onPostMessage()
    }
  }

  async onPostMessage() {
    let out = []
    // let X = Object.values(this.stat["VNINDEX"]s.T).sort((a, b) => {
    //   return a.T - b.T
    // })
    // let f = X.slice(X.length - 10)
    // f.forEach(e => {
    //   out.push({ time: moment(e.T, "X").format("HH:mm:ss"), ...flattenObject(e) })
    // })
    this.lastData.forEach(
      e => {
        out.push({ time: e.time, ...flattenObject(e) })
      }
    )
    if (out.length > 0) {
      out = out.map(e => {
        let ne = { ...e };
        let xx = ["vol", "val"]
        xx.forEach(v => {
          if (e["bu_" + v] && e["sd_" + v]) {
            ne["busd_" + v] = e["bu_" + v] - e["sd_" + v]

          }
        })
        return ne;
      })
      // console.table(out)
      // console.table([this.data[this.dataC - 1]])

      let d = this.data[this.dataC - 1];
      let timeline = {
        labels: [
          'time', 'VNINDEX',
          'T', 'unknown_vol',
          'unknown_val', 'bu_vol',
          'bu_val', 'sd_vol',
          'sd_val', 'busd_vol',
          'busd_val',
          'bid_vol',
          'bid_val',
          'ask_vol',
          'ask_val',
        ],
        data: out.map(e => {
          return [
            'time', 'VNINDEX',
            'T', 'unknown_vol',
            'unknown_val', 'bu_vol',
            'bu_val', 'sd_vol',
            'sd_val', 'busd_vol',
            'busd_val',
            'bid_vol',
            'bid_val',
            'ask_vol',
            'ask_val',
          ].map(ee => e[ee]
            // {
            //   if (ee.includes('vol') || ee.includes('val'))
            //     return numeral(e[ee]).format('0,0');
            //   else return e[ee]
            // }
          )
        })
      }

      // console.table(timeline.data)
      let stats = {
        labels: ["VNINDEX", "time", "date", "bid_vol", "bid_val", "ask_vol", "ask_val", "bu_vol", "bu_val", "sd_vol", "sd_val", "uk_vol", "uk_val", "busd_vol", "busd_val", "min_busd_val", "max_busd_val"],
        data: ["VNINDEX", "time", "date", "bid_vol", "bid_val", "ask_vol", "ask_val", "bu_vol", "bu_val", "sd_vol", "sd_val", "uk_vol", "uk_val", "busd_vol", "busd_val", "min_busd_val", "max_busd_val"].map(e =>
          d[e]
        )
      }

      // console.table(stats)
      if (parentPort)
        parentPort.postMessage({ data: null, timeline: timeline, stats: stats, type: '0' });
    }
    this.last = Date.now()
    this.lastDataLength = this.lastData.length;
  }

  async onMatched(message) {

  }

  count(a) {
    let c = 0;
    a.forEach(e => {
      // console.log(e)
      if (e.length > 0) c++;
    })
    return c;
  }
}

// async function sendMessageToClient(socket,topic, message) {
//   return new Promise((resolve, reject) => {
//     socket.emit(topic, message, (acknowledgment) => {
//       if (acknowledgment) {
//         resolve(acknowledgment);
//       } else {
//         reject(new Error('Lỗi khi gửi tin nhắn.'));
//       }
//     });
//   });
// }

function writeArrayJson2XlsxNew(filename, ...args) {
  let workbook = xlsx.utils.book_new();
  args.forEach(s => {
    let worksheet = xlsx.utils.json_to_sheet(s.data);
    if (s.name)
      xlsx.utils.book_append_sheet(workbook, worksheet, s.name);
    else
      xlsx.utils.book_append_sheet(workbook, worksheet);
  })
  xlsx.writeFile(workbook, filename);
}

let priceModel = new PriceModel()

// let map = { "AAA": "hose:21", "AAM": "hose:9", "AAT": "hose:702", "ABR": "hose:4413", "ABS": "hose:234", "ABT": "hose:3", "ACB": "hose:436", "ACC": "hose:15", "ACG": "hose:4619", "ACL": "hose:4", "ADG": "hose:682", "ADP": "hose:4787", "ADS": "hose:19", "AGG": "hose:156", "AGM": "hose:17", "AGR": "hose:10", "ANV": "hose:5", "APC": "hose:13", "APG": "hose:22", "APH": "hose:307", "ASG": "hose:354", "ASM": "hose:12", "ASP": "hose:7", "AST": "hose:24", "BAF": "hose:4356", "BBC": "hose:190", "BCE": "hose:212", "BCG": "hose:218", "BCM": "hose:338", "BFC": "hose:219", "BHN": "hose:220", "BIC": "hose:215", "BID": "hose:217", "BKG": "hose:447", "BMC": "hose:199", "BMI": "hose:206", "BMP": "hose:195", "BRC": "hose:216", "BSI": "hose:214", "BTP": "hose:210", "BTT": "hose:211", "BVH": "hose:209", "BWE": "hose:221", "C32": "hose:598", "C47": "hose:593", "CAV": "hose:601", "CCI": "hose:586", "CCL": "hose:592", "CDC": "hose:589", "CHP": "hose:604", "CIG": "hose:595", "CII": "hose:572", "CKG": "hose:236", "CLC": "hose:575", "CLL": "hose:599", "CLW": "hose:591", "CMG": "hose:583", "CMV": "hose:587", "CMX": "hose:590", "CNG": "hose:596", "COM": "hose:574", "CRC": "hose:46", "CRE": "hose:48", "CSM": "hose:581", "CSV": "hose:603", "CTD": "hose:582", "CTF": "hose:606", "CTG": "hose:580", "CTI": "hose:585", "CTR": "hose:4402", "CTS": "hose:607", "CVT": "hose:608", "D2D": "hose:642", "DAG": "hose:647", "DAH": "hose:658", "DAT": "hose:657", "DBC": "hose:101", "DBD": "hose:33", "DBT": "hose:397", "DC4": "hose:370", "DCL": "hose:640", "DCM": "hose:655", "DGC": "hose:308", "DGW": "hose:656", "DHA": "hose:622", "DHC": "hose:641", "DHG": "hose:629", "DHM": "hose:654", "DIG": "hose:643", "DLG": "hose:649", "DMC": "hose:631", "DPG": "hose:30", "DPM": "hose:634", "DPR": "hose:635", "DQC": "hose:637", "DRC": "hose:633", "DRH": "hose:651", "DRL": "hose:653", "DSN": "hose:652", "DTA": "hose:650", "DTL": "hose:648", "DTT": "hose:630", "DVP": "hose:644", "DXG": "hose:646", "DXS": "hose:3982", "DXV": "hose:638", "EIB": "hose:792", "ELC": "hose:793", "EVE": "hose:794", "EVF": "hose:4382", "EVG": "hose:797", "FCM": "hose:979", "FCN": "hose:978", "FDC": "hose:976", "FIR": "hose:53", "FIT": "hose:981", "FMC": "hose:973", "FPT": "hose:974", "FRT": "hose:26", "FTS": "hose:983", "FUCTVGF3": "hose:4281", "FUCTVGF4": "hose:4609", "FUCVREIT": "hose:985", "GAS": "hose:1152", "GDT": "hose:1149", "GEG": "hose:108", "GEX": "hose:1154", "GIL": "hose:1145", "GMC": "hose:1147", "GMD": "hose:1146", "GMH": "hose:4383", "GSP": "hose:1151", "GTA": "hose:1148", "GVR": "hose:233", "HAG": "hose:1364", "HAH": "hose:1380", "HAP": "hose:1291", "HAR": "hose:1379", "HAS": "hose:1292", "HAX": "hose:1337", "HBC": "hose:1339", "HCD": "hose:1382", "HCM": "hose:1366", "HDB": "hose:1386", "HDC": "hose:1348", "HDG": "hose:1369", "HHP": "hose:685", "HHS": "hose:1378", "HHV": "hose:4396", "HID": "hose:1383", "HII": "hose:1384", "HMC": "hose:1336", "HNG": "hose:1381", "HPG": "hose:1354", "HPX": "hose:41", "HQC": "hose:1372", "HRC": "hose:1338", "HSG": "hose:1363", "HSL": "hose:28", "HT1": "hose:1351", "HTI": "hose:1373", "HTL": "hose:1374", "HTN": "hose:58", "HTV": "hose:1318", "HU1": "hose:1377", "HUB": "hose:68", "HVH": "hose:60", "HVN": "hose:69", "HVX": "hose:1371", "IBC": "hose:1422", "ICT": "hose:163", "IDI": "hose:1420", "IJC": "hose:1419", "ILB": "hose:70", "IMP": "hose:1416", "ITA": "hose:1415", "ITC": "hose:1418", "ITD": "hose:1421", "JVC": "hose:1604", "KBC": "hose:1731", "KDC": "hose:1727", "KDH": "hose:1734", "KHG": "hose:3984", "KHP": "hose:1728", "KMR": "hose:1729", "KOS": "hose:100", "KPF": "hose:1738", "KSB": "hose:1733", "L10": "hose:1891", "LAF": "hose:1888", "LBM": "hose:1889", "LCG": "hose:1893", "LDG": "hose:1899", "LEC": "hose:1900", "LGC": "hose:1890", "LGL": "hose:1894", "LHG": "hose:1896", "LIX": "hose:1895", "LM8": "hose:1897", "LPB": "hose:416", "LSS": "hose:1892", "MBB": "hose:2027", "MCP": "hose:2019", "MDG": "hose:2026", "MHC": "hose:2017", "MIG": "hose:666", "MSB": "hose:443", "MSH": "hose:59", "MSN": "hose:2024", "MWG": "hose:2028", "NAF": "hose:2199", "NAV": "hose:2186", "NBB": "hose:2188", "NCT": "hose:2197", "NHA": "hose:667", "NHH": "hose:145", "NHT": "hose:4321", "NKG": "hose:2195", "NLG": "hose:2196", "NNC": "hose:2193", "NO1": "hose:4639", "NSC": "hose:2185", "NT2": "hose:2198", "NTL": "hose:2187", "NVL": "hose:2200", "NVT": "hose:2191", "OCB": "hose:670", "OGC": "hose:2340", "OPC": "hose:2339", "ORS": "hose:4301", "PAC": "hose:2549", "PAN": "hose:2570", "PC1": "hose:2575", "PDN": "hose:2573", "PDR": "hose:2567", "PET": "hose:2552", "PGC": "hose:2546", "PGD": "hose:2560", "PGI": "hose:2572", "PGV": "hose:4401", "PHC": "hose:50", "PHR": "hose:2558", "PIT": "hose:2554", "PJT": "hose:2550", "PLP": "hose:2577", "PLX": "hose:2576", "PMG": "hose:2579", "PNC": "hose:2545", "PNJ": "hose:2557", "POM": "hose:2562", "POW": "hose:66", "PPC": "hose:2551", "PSH": "hose:288", "PTB": "hose:2571", "PTC": "hose:2556", "PTL": "hose:2568", "PVD": "hose:2548", "PVP": "hose:4662", "PVT": "hose:2553", "QBS": "hose:2698", "QCG": "hose:2697", "RAL": "hose:2737", "RDP": "hose:2739", "REE": "hose:2735", "S4A": "hose:2944", "SAB": "hose:2947", "SAM": "hose:2902", "SAV": "hose:2904", "SBA": "hose:2932", "SBT": "hose:2923", "SBV": "hose:2948", "SC5": "hose:2919", "SCD": "hose:2914", "SCR": "hose:2945", "SCS": "hose:43", "SFC": "hose:2905", "SFG": "hose:2942", "SFI": "hose:2918", "SGN": "hose:42", "SGR": "hose:2950", "SGT": "hose:2922", "SHA": "hose:2946", "SHB": "hose:4126", "SHI": "hose:2928", "SHP": "hose:2941", "SIP": "hose:4802", "SJD": "hose:2912", "SJF": "hose:2949", "SJS": "hose:2907", "SKG": "hose:2940", "SMA": "hose:2935", "SMB": "hose:44", "SMC": "hose:2911", "SPM": "hose:2931", "SRC": "hose:2926", "SRF": "hose:2927", "SSB": "hose:703", "SSC": "hose:2906", "SSI": "hose:2920", "ST8": "hose:2921", "STB": "hose:2908", "STG": "hose:2930", "STK": "hose:2943", "SVC": "hose:2925", "SVD": "hose:671", "SVI": "hose:2938", "SVT": "hose:2937", "SZC": "hose:67", "SZL": "hose:2924", "TBC": "hose:3489", "TCB": "hose:32", "TCD": "hose:3507", "TCH": "hose:3506", "TCL": "hose:3492", "TCM": "hose:3483", "TCO": "hose:3502", "TCR": "hose:3479", "TCT": "hose:3504", "TDC": "hose:3496", "TDG": "hose:3510", "TDH": "hose:3476", "TDM": "hose:55", "TDP": "hose:367", "TDW": "hose:3499", "TEG": "hose:3514", "TGG": "hose:31", "THG": "hose:3501", "TIP": "hose:3505", "TIX": "hose:3490", "TLD": "hose:3512", "TLG": "hose:3495", "TLH": "hose:3494", "TMP": "hose:3487", "TMS": "hose:3275", "TMT": "hose:3493", "TN1": "hose:73", "TNA": "hose:3362", "TNC": "hose:3481", "TNH": "hose:612", "TNI": "hose:3508", "TNT": "hose:3497", "TPB": "hose:25", "TPC": "hose:3484", "TRA": "hose:3486", "TRC": "hose:3480", "TSC": "hose:3482", "TTA": "hose:348", "TTB": "hose:45", "TTE": "hose:61", "TTF": "hose:3485", "TV2": "hose:74", "TVB": "hose:36", "TVS": "hose:3503", "TVT": "hose:3511", "TYA": "hose:3434", "UIC": "hose:3637", "VAF": "hose:3841", "VCA": "hose:701", "VCB": "hose:3825", "VCF": "hose:3840", "VCG": "hose:446", "VCI": "hose:3849", "VDP": "hose:3851", "VDS": "hose:3850", "VFG": "hose:3830", "VGC": "hose:72", "VHC": "hose:3815", "VHM": "hose:29", "VIB": "hose:417", "VIC": "hose:3813", "VID": "hose:3808", "VIP": "hose:3807", "VIX": "hose:613", "VJC": "hose:3847", "VMD": "hose:3837", "VND": "hose:3853", "VNE": "hose:3812", "VNG": "hose:3829", "VNL": "hose:3826", "VNM": "hose:3801", "VNS": "hose:3821", "VOS": "hose:3835", "VPB": "hose:3852", "VPD": "hose:3858", "VPG": "hose:3857", "VPH": "hose:3827", "VPI": "hose:37", "VPS": "hose:3842", "VRC": "hose:3833", "VRE": "hose:3854", "VSC": "hose:3816", "VSH": "hose:3802", "VSI": "hose:3839", "VTB": "hose:3810", "VTO": "hose:3814", "YBM": "hose:47", "YEG": "hose:34", "AAV": "hnx:77359", "ADC": "hnx:14696", "ALT": "hnx:6864", "AMC": "hnx:17616", "AME": "hnx:9464", "AMV": "hnx:8144", "API": "hnx:13273", "APS": "hnx:9064", "ARM": "hnx:13072", "ATS": "hnx:74402", "BAB": "hnx:76841", "BAX": "hnx:75742", "BBS": "hnx:121", "BCC": "hnx:921", "BCF": "hnx:79161", "BDB": "hnx:8184", "BED": "hnx:7344", "BKC": "hnx:7064", "BLF": "hnx:4576", "BNA": "hnx:79621", "BPC": "hnx:6386", "BSC": "hnx:13575", "BST": "hnx:5704", "BTS": "hnx:1064", "BTW": "hnx:54585", "BVS": "hnx:1301", "BXH": "hnx:7764", "C69": "hnx:75944", "CAG": "hnx:76646", "CAN": "hnx:6485", "CAP": "hnx:3524", "CCR": "hnx:73724", "CDN": "hnx:74420", "CEO": "hnx:72819", "CET": "hnx:76339", "CIA": "hnx:76740", "CJC": "hnx:1161", "CKV": "hnx:8064", "CLH": "hnx:74679", "CLM": "hnx:74499", "CMC": "hnx:1202", "CMS": "hnx:14256", "CPC": "hnx:8304", "CSC": "hnx:7604", "CTB": "hnx:702", "CTC": "hnx:4704", "CTP": "hnx:74879", "CTT": "hnx:73519", "CTX": "hnx:18196", "CVN": "hnx:10332", "CX8": "hnx:8644", "D11": "hnx:14896", "DAD": "hnx:7084", "DAE": "hnx:1461", "DC2": "hnx:11832", "DDG": "hnx:77940", "DHP": "hnx:20856", "DHT": "hnx:5484", "DIH": "hnx:15196", "DL1": "hnx:8324", "DNC": "hnx:7864", "DNP": "hnx:6664", "DP3": "hnx:73499", "DPC": "hnx:6484", "DS3": "hnx:76419", "DST": "hnx:2824", "DTC": "hnx:71837", "DTD": "hnx:76662", "DTG": "hnx:75686", "DTK": "hnx:75420", "DVG": "hnx:79841", "DVM": "hnx:81184", "DXP": "hnx:81", "DZM": "hnx:6364", "EBS": "hnx:1281", "ECI": "hnx:6344", "EID": "hnx:6924", "EVS": "hnx:77579", "FID": "hnx:73379", "GDW": "hnx:54904", "GIC": "hnx:79701", "GKM": "hnx:76302", "GLT": "hnx:7804", "GMA": "hnx:79721", "GMX": "hnx:16476", "HAD": "hnx:7444", "HAT": "hnx:13975", "HBS": "hnx:11672", "HCC": "hnx:3365", "HCT": "hnx:3064", "HDA": "hnx:14576", "HEV": "hnx:3264", "HGM": "hnx:7965", "HHC": "hnx:2984", "HJS": "hnx:1342", "HKT": "hnx:75525", "HLC": "hnx:6204", "HLD": "hnx:20916", "HMH": "hnx:12193", "HMR": "hnx:80841", "HOM": "hnx:6724", "HTC": "hnx:8884", "HTP": "hnx:1201", "HUT": "hnx:4204", "HVT": "hnx:6264", "ICG": "hnx:6244", "IDC": "hnx:76739", "IDJ": "hnx:13032", "IDV": "hnx:9444", "INC": "hnx:16836", "INN": "hnx:8264", "IPA": "hnx:74719", "ITQ": "hnx:18716", "IVS": "hnx:16616", "KDM": "hnx:74401", "KHS": "hnx:76821", "KKC": "hnx:4864", "KLF": "hnx:72339", "KMT": "hnx:14636", "KSD": "hnx:9084", "KSF": "hnx:80521", "KSQ": "hnx:22357", "KST": "hnx:12892", "KSV": "hnx:74860", "KTS": "hnx:14856", "KTT": "hnx:13695", "L14": "hnx:16676", "L18": "hnx:4184", "L40": "hnx:79882", "L43": "hnx:4224", "L61": "hnx:5264", "L62": "hnx:4125", "LAS": "hnx:17996", "LBE": "hnx:3804", "LCD": "hnx:13595", "LDP": "hnx:11072", "LHC": "hnx:8224", "LIG": "hnx:8824", "MAC": "hnx:8024", "MAS": "hnx:54124", "MBG": "hnx:74019", "MBS": "hnx:74399", "MCC": "hnx:8784", "MCF": "hnx:15056", "MCO": "hnx:1082", "MDC": "hnx:6684", "MED": "hnx:79181", "MEL": "hnx:76522", "MHL": "hnx:7824", "MIM": "hnx:12612", "MKV": "hnx:5564", "MST": "hnx:74539", "MVB": "hnx:75139", "NAG": "hnx:7144", "NAP": "hnx:74821", "NBC": "hnx:1721", "NBP": "hnx:6844", "NBW": "hnx:54744", "NDN": "hnx:15716", "NDX": "hnx:22319", "NET": "hnx:12713", "NFC": "hnx:72519", "NHC": "hnx:6564", "NRC": "hnx:77079", "NSH": "hnx:76287", "NST": "hnx:1762", "NTH": "hnx:78460", "NTP": "hnx:1181", "NVB": "hnx:12072", "OCH": "hnx:13415", "ONE": "hnx:4664", "PBP": "hnx:73140", "PCE": "hnx:73521", "PCG": "hnx:14816", "PCH": "hnx:81243", "PCT": "hnx:17216", "PDB": "hnx:73599", "PEN": "hnx:72800", "PGN": "hnx:78521", "PGS": "hnx:3024", "PGT": "hnx:8025", "PHN": "hnx:78199", "PIA": "hnx:75683", "PIC": "hnx:73579", "PJC": "hnx:1601", "PLC": "hnx:1502", "PMB": "hnx:73760", "PMC": "hnx:7284", "PMP": "hnx:73740", "PMS": "hnx:6387", "POT": "hnx:1362", "PPE": "hnx:16636", "PPP": "hnx:16896", "PPS": "hnx:14916", "PPT": "hnx:81102", "PPY": "hnx:74321", "PRC": "hnx:14081", "PRE": "hnx:79782", "PSC": "hnx:1681", "PSD": "hnx:22297", "PSE": "hnx:73219", "PSI": "hnx:12092", "PSW": "hnx:73480", "PTD": "hnx:60792", "PTI": "hnx:14556", "PTS": "hnx:962", "PV2": "hnx:14416", "PVB": "hnx:72460", "PVC": "hnx:3004", "PVG": "hnx:5904", "PVI": "hnx:2624", "PVS": "hnx:2724", "QHD": "hnx:8504", "QST": "hnx:5664", "QTC": "hnx:5984", "RCL": "hnx:2242", "S55": "hnx:1503", "S99": "hnx:1521", "SAF": "hnx:6424", "SCG": "hnx:79982", "SCI": "hnx:72659", "SD5": "hnx:1703", "SD6": "hnx:1561", "SD9": "hnx:1402", "SDA": "hnx:1403", "SDC": "hnx:1603", "SDG": "hnx:8065", "SDN": "hnx:6624", "SDT": "hnx:1262", "SDU": "hnx:7204", "SEB": "hnx:6045", "SED": "hnx:7004", "SFN": "hnx:6524", "SGC": "hnx:6584", "SGD": "hnx:1682", "SGH": "hnx:6944", "SHE": "hnx:78100", "SHN": "hnx:8044", "SHS": "hnx:6604", "SJ1": "hnx:6444", "SJE": "hnx:1261", "SLS": "hnx:19696", "SMN": "hnx:73481", "SMT": "hnx:9504", "SPC": "hnx:55324", "SPI": "hnx:19316", "SRA": "hnx:3704", "SSM": "hnx:5425", "STC": "hnx:1541", "STP": "hnx:742", "SVN": "hnx:16957", "SZB": "hnx:78961", "TA9": "hnx:73559", "TAR": "hnx:78140", "TBX": "hnx:5224", "TC6": "hnx:4126", "TDN": "hnx:5424", "TDT": "hnx:77519", "TET": "hnx:8944", "TFC": "hnx:74021", "THB": "hnx:5404", "THD": "hnx:79421", "THS": "hnx:72419", "THT": "hnx:5284", "TIG": "hnx:13495", "TJC": "hnx:3364", "TKC": "hnx:7844", "TKG": "hnx:79981", "TKU": "hnx:261", "TMB": "hnx:75542", "TMC": "hnx:6404", "TMX": "hnx:7424", "TNG": "hnx:3104", "TOT": "hnx:76282", "TPH": "hnx:1341", "TPP": "hnx:4784", "TSB": "hnx:14976", "TTC": "hnx:8244", "TTH": "hnx:75179", "TTL": "hnx:76879", "TTT": "hnx:76081", "TTZ": "hnx:20036", "TV3": "hnx:7784", "TV4": "hnx:4284", "TVC": "hnx:72783", "TVD": "hnx:14776", "TXM": "hnx:1141", "UNI": "hnx:6405", "V12": "hnx:7704", "V21": "hnx:8664", "VBC": "hnx:8384", "VC1": "hnx:6304", "VC2": "hnx:1101", "VC3": "hnx:3304", "VC6": "hnx:3784", "VC7": "hnx:3546", "VC9": "hnx:7184", "VCC": "hnx:5964", "VCM": "hnx:9264", "VCS": "hnx:3284", "VDL": "hnx:2864", "VE1": "hnx:4844", "VE3": "hnx:10050", "VE4": "hnx:19637", "VE8": "hnx:19416", "VFS": "hnx:79422", "VGP": "hnx:6464", "VGS": "hnx:5584", "VHE": "hnx:78059", "VHL": "hnx:5725", "VIF": "hnx:75522", "VIG": "hnx:7884", "VIT": "hnx:7624", "VLA": "hnx:11692", "VMC": "hnx:1083", "VMS": "hnx:73820", "VNC": "hnx:1481", "VNF": "hnx:13132", "VNR": "hnx:141", "VNT": "hnx:7024", "VSA": "hnx:74104", "VSM": "hnx:76239", "VTC": "hnx:6388", "VTH": "hnx:72919", "VTJ": "hnx:73079", "VTV": "hnx:1241", "VTZ": "hnx:80563", "WCS": "hnx:11272", "WSS": "hnx:7984", "X20": "hnx:76939", "A32": "upcom:77800", "AAS": "upcom:79481", "ABB": "upcom:79784", "ABC": "upcom:74941", "ABI": "upcom:54064", "ABW": "upcom:81681", "ACE": "upcom:54244", "ACM": "upcom:73539", "ACS": "upcom:76281", "ACV": "upcom:75320", "AFX": "upcom:75301", "AG1": "upcom:76851", "AGF": "upcom:79142", "AGP": "upcom:73759", "AGX": "upcom:73680", "AIC": "upcom:79821", "ALV": "upcom:12732", "AMD": "upcom:72979", "AMP": "upcom:75541", "AMS": "upcom:75639", "ANT": "upcom:75408", "APF": "upcom:76120", "APL": "upcom:75120", "APP": "upcom:13414", "APT": "upcom:78379", "ART": "upcom:76361", "ASA": "upcom:17796", "ATA": "upcom:75662", "ATB": "upcom:76480", "ATG": "upcom:80161", "AVC": "upcom:76859", "AVF": "upcom:73459", "B82": "upcom:4044", "BAL": "upcom:76863", "BBH": "upcom:79321", "BBM": "upcom:76826", "BBT": "upcom:77321", "BCA": "upcom:80461", "BCB": "upcom:77840", "BCP": "upcom:73699", "BCV": "upcom:79901", "BDG": "upcom:74443", "BDT": "upcom:76499", "BDW": "upcom:73779", "BEL": "upcom:74799", "BGW": "upcom:76641", "BHA": "upcom:76360", "BHC": "upcom:6324", "BHG": "upcom:77839", "BHI": "upcom:81821", "BHK": "upcom:77119", "BHP": "upcom:71236", "BIG": "upcom:80822", "BII": "upcom:72781", "BIO": "upcom:77699", "BLI": "upcom:74080", "BLN": "upcom:74979", "BLT": "upcom:76279", "BLW": "upcom:77819", "BMD": "upcom:76102", "BMF": "upcom:77140", "BMG": "upcom:77999", "BMJ": "upcom:54325", "BMN": "upcom:74441", "BMS": "upcom:77639", "BMV": "upcom:76100", "BNW": "upcom:78019", "BOT": "upcom:78159", "BQB": "upcom:76845", "BRR": "upcom:76160", "BRS": "upcom:75582", "BSA": "upcom:77679", "BSD": "upcom:75999", "BSG": "upcom:75299", "BSH": "upcom:77461", "BSL": "upcom:76103", "BSP": "upcom:74899", "BSQ": "upcom:75699", "BSR": "upcom:76999", "BT1": "upcom:75219", "BT6": "upcom:75719", "BTB": "upcom:75519", "BTD": "upcom:75700", "BTG": "upcom:54805", "BTH": "upcom:3547", "BTN": "upcom:76828", "BTU": "upcom:74340", "BTV": "upcom:75669", "BVB": "upcom:79441", "BVG": "upcom:12532", "BVL": "upcom:80281", "BVN": "upcom:62572", "BWA": "upcom:54925", "BWS": "upcom:76721", "C12": "upcom:75413", "C21": "upcom:75180", "C22": "upcom:77259", "C4G": "upcom:77939", "C92": "upcom:3044", "CAB": "upcom:78719", "CAD": "upcom:69076", "CAR": "upcom:81161", "CAT": "upcom:77061", "CBI": "upcom:76525", "CBS": "upcom:76162", "CC1": "upcom:76285", "CC4": "upcom:76325", "CCA": "upcom:78963", "CCM": "upcom:5044", "CCP": "upcom:75760", "CCT": "upcom:76260", "CCV": "upcom:75505", "CDG": "upcom:75666", "CDH": "upcom:74739", "CDO": "upcom:77762", "CDP": "upcom:77499", "CDR": "upcom:76182", "CE1": "upcom:75879", "CEG": "upcom:76060", "CEN": "upcom:77341", "CFM": "upcom:79881", "CFV": "upcom:78360", "CGV": "upcom:76199", "CH5": "upcom:76122", "CHC": "upcom:75659", "CHS": "upcom:75526", "CI5": "upcom:65096", "CID": "upcom:9", "CIP": "upcom:76524", "CK8": "upcom:81524", "CKA": "upcom:77765", "CKD": "upcom:73380", "CLG": "upcom:80081", "CLX": "upcom:75720", "CMD": "upcom:78523", "CMF": "upcom:75341", "CMI": "upcom:11552", "CMK": "upcom:73839", "CMM": "upcom:81421", "CMN": "upcom:76280", "CMP": "upcom:74279", "CMT": "upcom:78279", "CMW": "upcom:75899", "CNA": "upcom:80641", "CNC": "upcom:72639", "CNN": "upcom:74660", "CNT": "upcom:73203", "CPA": "upcom:78981", "CPH": "upcom:75622", "CPI": "upcom:76322", "CQN": "upcom:79541", "CQT": "upcom:75222", "CSI": "upcom:78239", "CST": "upcom:80062", "CT3": "upcom:54245", "CT6": "upcom:8984", "CTA": "upcom:13294", "CTN": "upcom:1401", "CTW": "upcom:75060", "CYC": "upcom:76063", "DAC": "upcom:642", "DAN": "upcom:80661", "DAS": "upcom:72780", "DBM": "upcom:54384", "DC1": "upcom:74839", "DCF": "upcom:75540", "DCG": "upcom:77941", "DCH": "upcom:77180", "DCR": "upcom:77779", "DCS": "upcom:3344", "DCT": "upcom:74445", "DDH": "upcom:74779", "DDM": "upcom:73059", "DDN": "upcom:54046", "DDV": "upcom:73441", "DFC": "upcom:75520", "DFF": "upcom:80322", "DGT": "upcom:54485", "DHB": "upcom:76323", "DHD": "upcom:76019", "DHN": "upcom:77159", "DIC": "upcom:79521", "DID": "upcom:7964", "DKC": "upcom:79461", "DLD": "upcom:62992", "DLM": "upcom:81523", "DLR": "upcom:9104", "DLT": "upcom:73939", "DM7": "upcom:77763", "DMN": "upcom:80562", "DMS": "upcom:81741", "DNA": "upcom:76639", "DND": "upcom:75241", "DNE": "upcom:75880", "DNH": "upcom:76161", "DNL": "upcom:66156", "DNM": "upcom:14216", "DNN": "upcom:76283", "DNT": "upcom:54086", "DNW": "upcom:74359", "DOC": "upcom:75409", "DOP": "upcom:73879", "DP1": "upcom:77339", "DP2": "upcom:76061", "DPH": "upcom:75579", "DPP": "upcom:55084", "DPS": "upcom:73359", "DRG": "upcom:78921", "DRI": "upcom:76062", "DSC": "upcom:76862", "DSD": "upcom:80962", "DSG": "upcom:76380", "DSP": "upcom:77764", "DSV": "upcom:75359", "DTB": "upcom:78619", "DTE": "upcom:79785", "DTH": "upcom:80901", "DTI": "upcom:76843", "DTP": "upcom:79401", "DTV": "upcom:54787", "DUS": "upcom:79043", "DVC": "upcom:72439", "DVN": "upcom:76022", "DVW": "upcom:77299", "DWC": "upcom:80681", "DWS": "upcom:78099", "DXL": "upcom:55025", "E12": "upcom:79021", "E29": "upcom:78842", "EFI": "upcom:7264", "EIC": "upcom:75670", "EIN": "upcom:75743", "EME": "upcom:76304", "EMG": "upcom:75663", "EMS": "upcom:76827", "EPC": "upcom:77760", "EPH": "upcom:76819", "FBA": "upcom:64996", "FBC": "upcom:76621", "FCC": "upcom:74559", "FCS": "upcom:75667", "FGL": "upcom:77721", "FHN": "upcom:76840", "FHS": "upcom:77859", "FIC": "upcom:77599", "FLC": "upcom:16996", "FOC": "upcom:77959", "FOX": "upcom:75487", "FRC": "upcom:77540", "FRM": "upcom:76679", "FSO": "upcom:75589", "FT1": "upcom:76523", "FTI": "upcom:76626", "FTM": "upcom:81042", "G20": "upcom:73199", "G36": "upcom:75439", "GAB": "upcom:81801", "GCB": "upcom:75460", "GCF": "upcom:81461", "GDA": "upcom:81921", "GEE": "upcom:80881", "GER": "upcom:55364", "GGG": "upcom:7404", "GH3": "upcom:80364", "GHC": "upcom:64316", "GLC": "upcom:78039", "GLW": "upcom:76844", "GND": "upcom:75685", "GPC": "upcom:81522", "GSM": "upcom:73319", "GTD": "upcom:75401", "GTS": "upcom:75162", "GTT": "upcom:74661", "GVT": "upcom:75521", "H11": "upcom:64616", "HAC": "upcom:75121", "HAF": "upcom:76320", "HAI": "upcom:81561", "HAM": "upcom:76403", "HAN": "upcom:75160", "HAV": "upcom:76723", "HBD": "upcom:72319", "HBH": "upcom:76379", "HC1": "upcom:79024", "HC3": "upcom:76299", "HCB": "upcom:78941", "HCI": "upcom:61292", "HD2": "upcom:74579", "HD6": "upcom:79741", "HD8": "upcom:78219", "HDM": "upcom:54524", "HDO": "upcom:11352", "HDP": "upcom:75740", "HDW": "upcom:76628", "HEC": "upcom:75424", "HEJ": "upcom:76300", "HEM": "upcom:75486", "HEP": "upcom:76782", "HES": "upcom:75399", "HFB": "upcom:75839", "HFC": "upcom:54566", "HFX": "upcom:61073", "HGT": "upcom:79642", "HGW": "upcom:75523", "HHG": "upcom:12292", "HHN": "upcom:75423", "HHR": "upcom:75664", "HIG": "upcom:54044", "HJC": "upcom:73819", "HKB": "upcom:73279", "HLA": "upcom:73239", "HLB": "upcom:75620", "HLR": "upcom:75302", "HLS": "upcom:76619", "HLT": "upcom:78965", "HLY": "upcom:1543", "HMG": "upcom:74981", "HMS": "upcom:76079", "HNA": "upcom:76580", "HNB": "upcom:73822", "HND": "upcom:75099", "HNF": "upcom:73899", "HNI": "upcom:76759", "HNM": "upcom:1623", "HNP": "upcom:75407", "HNR": "upcom:77319", "HOT": "upcom:81581", "HPB": "upcom:8524", "HPD": "upcom:73439", "HPH": "upcom:76839", "HPI": "upcom:76560", "HPM": "upcom:74219", "HPP": "upcom:54544", "HPT": "upcom:54504", "HPW": "upcom:75319", "HRB": "upcom:76630", "HRT": "upcom:74982", "HSA": "upcom:75585", "HSI": "upcom:73360", "HSM": "upcom:77160", "HSP": "upcom:79221", "HSV": "upcom:80061", "HTE": "upcom:76319", "HTG": "upcom:76101", "HTM": "upcom:77219", "HTT": "upcom:79403", "HU3": "upcom:81622", "HU4": "upcom:74261", "HU6": "upcom:73979", "HUG": "upcom:76783", "HVA": "upcom:73580", "HVG": "upcom:79501", "HWS": "upcom:77541", "IBD": "upcom:78340", "ICC": "upcom:74659", "ICF": "upcom:78319", "ICI": "upcom:54804", "ICN": "upcom:73442", "IDP": "upcom:79822", "IFS": "upcom:75243", "IHK": "upcom:54484", "ILA": "upcom:76741", "ILC": "upcom:77659", "ILS": "upcom:77040", "IME": "upcom:54284", "IN4": "upcom:54964", "IRC": "upcom:76899", "ISG": "upcom:73722", "ISH": "upcom:73462", "IST": "upcom:75504", "ITS": "upcom:74103", "JOS": "upcom:76321", "KAC": "upcom:78721", "KCB": "upcom:74020", "KCE": "upcom:64156", "KGM": "upcom:76521", "KHD": "upcom:75425", "KHL": "upcom:17016", "KHW": "upcom:75684", "KIP": "upcom:74480", "KLB": "upcom:76180", "KLM": "upcom:78966", "KSH": "upcom:78723", "KTC": "upcom:77399", "KTL": "upcom:73119", "KVC": "upcom:73300", "L12": "upcom:75483", "L35": "upcom:8364", "L44": "upcom:8104", "L45": "upcom:75161", "L63": "upcom:75080", "LAI": "upcom:73601", "LAW": "upcom:74081", "LBC": "upcom:76402", "LCC": "upcom:54924", "LCM": "upcom:81341", "LCS": "upcom:11612", "LDW": "upcom:77039", "LG9": "upcom:76784", "LGM": "upcom:78962", "LIC": "upcom:76082", "LKW": "upcom:67556", "LLM": "upcom:76384", "LM3": "upcom:7845", "LM7": "upcom:13515", "LMC": "upcom:76520", "LMH": "upcom:79402", "LMI": "upcom:76288", "LNC": "upcom:78519", "LO5": "upcom:8004", "LPT": "upcom:79961", "LQN": "upcom:75221", "LSG": "upcom:80961", "LTC": "upcom:1063", "LTG": "upcom:76286", "LUT": "upcom:3544", "M10": "upcom:76864", "MA1": "upcom:79423", "MBN": "upcom:77761", "MCD": "upcom:81401", "MCG": "upcom:81661", "MCH": "upcom:75503", "MCM": "upcom:79781", "MDA": "upcom:76850", "MDF": "upcom:55104", "MEC": "upcom:1264", "MEF": "upcom:64456", "MES": "upcom:75380", "MFS": "upcom:78259", "MGC": "upcom:74699", "MGG": "upcom:76629", "MGR": "upcom:80921", "MH3": "upcom:75739", "MIC": "upcom:3424", "MIE": "upcom:76799", "MKP": "upcom:76919", "MLC": "upcom:76024", "MLS": "upcom:75459", "MML": "upcom:78922", "MNB": "upcom:77199", "MND": "upcom:76383", "MPC": "upcom:76602", "MPT": "upcom:74239", "MPY": "upcom:76021", "MQB": "upcom:76644", "MQN": "upcom:77419", "MRF": "upcom:76761", "MSR": "upcom:73719", "MTA": "upcom:73823", "MTB": "upcom:79763", "MTC": "upcom:67136", "MTG": "upcom:73461", "MTH": "upcom:62452", "MTL": "upcom:74540", "MTP": "upcom:62792", "MTS": "upcom:75979", "MTV": "upcom:76401", "MVC": "upcom:75799", "MVN": "upcom:77782", "NAB": "upcom:79622", "NAC": "upcom:75780", "NAS": "upcom:75588", "NAU": "upcom:77420", "NAW": "upcom:76359", "NBE": "upcom:76420", "NBT": "upcom:74639", "NCS": "upcom:74039", "ND2": "upcom:62152", "NDC": "upcom:54765", "NDF": "upcom:72779", "NDP": "upcom:73959", "NDT": "upcom:77719", "NDW": "upcom:78421", "NED": "upcom:76421", "NGC": "upcom:3764", "NHP": "upcom:73201", "NHV": "upcom:76119", "NJC": "upcom:79783", "NLS": "upcom:74859", "NNT": "upcom:55085", "NOS": "upcom:63775", "NQB": "upcom:73479", "NQN": "upcom:77379", "NQT": "upcom:75379", "NS2": "upcom:75303", "NSG": "upcom:74619", "NSL": "upcom:78599", "NSS": "upcom:77841", "NTB": "upcom:72479", "NTC": "upcom:75422", "NTF": "upcom:78522", "NTT": "upcom:76822", "NTW": "upcom:67356", "NUE": "upcom:75680", "NVP": "upcom:75421", "NWT": "upcom:74439", "NXT": "upcom:80621", "ODE": "upcom:80785", "OIL": "upcom:77019", "ONW": "upcom:75682", "PAI": "upcom:75583", "PAP": "upcom:80341", "PAS": "upcom:79601", "PAT": "upcom:81101", "PBC": "upcom:78901", "PBT": "upcom:78079", "PCC": "upcom:76659", "PCF": "upcom:75819", "PCM": "upcom:76381", "PCN": "upcom:74102", "PDC": "upcom:7244", "PDV": "upcom:75940", "PEC": "upcom:62492", "PEG": "upcom:77860", "PEQ": "upcom:74220", "PFL": "upcom:14036", "PGB": "upcom:79801", "PHH": "upcom:8564", "PHP": "upcom:73619", "PHS": "upcom:10852", "PID": "upcom:19756", "PIS": "upcom:74200", "PIV": "upcom:12672", "PJS": "upcom:67676", "PLA": "upcom:76648", "PLE": "upcom:79786", "PLO": "upcom:79241", "PMJ": "upcom:74759", "PMT": "upcom:61452", "PMW": "upcom:78559", "PND": "upcom:75660", "PNG": "upcom:74419", "PNP": "upcom:78299", "PNT": "upcom:75539", "POB": "upcom:76526", "POS": "upcom:75322", "POV": "upcom:62812", "PPH": "upcom:76404", "PPI": "upcom:78339", "PQN": "upcom:78781", "PRO": "upcom:72782", "PRT": "upcom:77220", "PSB": "upcom:54725", "PSG": "upcom:15156", "PSL": "upcom:54785", "PSN": "upcom:76219", "PSP": "upcom:54264", "PTE": "upcom:73540", "PTG": "upcom:54326", "PTH": "upcom:54604", "PTN": "upcom:81381", "PTO": "upcom:76140", "PTP": "upcom:54324", "PTT": "upcom:55164", "PTV": "upcom:78861", "PTX": "upcom:77560", "PVA": "upcom:5824", "PVE": "upcom:3545", "PVH": "upcom:76059", "PVL": "upcom:8924", "PVM": "upcom:75404", "PVO": "upcom:74201", "PVR": "upcom:10952", "PVV": "upcom:12932", "PVX": "upcom:7044", "PVY": "upcom:76825", "PWA": "upcom:78420", "PWS": "upcom:76261", "PX1": "upcom:63535", "PXA": "upcom:15356", "PXC": "upcom:75584", "PXI": "upcom:80981", "PXL": "upcom:74620", "PXM": "upcom:72679", "PXS": "upcom:81141", "PXT": "upcom:80241", "QCC": "upcom:12512", "QHW": "upcom:75411", "QNC": "upcom:3726", "QNS": "upcom:75426", "QNT": "upcom:79042", "QNU": "upcom:75668", "QNW": "upcom:75461", "QPH": "upcom:72699", "QSP": "upcom:75039", "QTP": "upcom:75746", "RAT": "upcom:74919", "RBC": "upcom:74280", "RCC": "upcom:75361", "RCD": "upcom:73179", "RGC": "upcom:76159", "RIC": "upcom:81021", "RTB": "upcom:75239", "S12": "upcom:3624", "S27": "upcom:73039", "S72": "upcom:77260", "S74": "upcom:6644", "S96": "upcom:3584", "SAC": "upcom:75240", "SAL": "upcom:76622", "SAP": "upcom:1263", "SAS": "upcom:73301", "SB1": "upcom:75441", "SBD": "upcom:75681", "SBH": "upcom:77320", "SBL": "upcom:75599", "SBM": "upcom:76519", "SBR": "upcom:79661", "SBS": "upcom:72579", "SCC": "upcom:72739", "SCJ": "upcom:2704", "SCL": "upcom:12632", "SCO": "upcom:61812", "SCY": "upcom:76624", "SD1": "upcom:11974", "SD2": "upcom:3204", "SD3": "upcom:72459", "SD4": "upcom:4304", "SD7": "upcom:1702", "SD8": "upcom:74159", "SDB": "upcom:8404", "SDD": "upcom:3745", "SDJ": "upcom:72839", "SDK": "upcom:59847", "SDP": "upcom:6284", "SDV": "upcom:64736", "SDX": "upcom:73725", "SDY": "upcom:1545", "SEA": "upcom:75440", "SEP": "upcom:75587", "SGB": "upcom:79641", "SGI": "upcom:80481", "SGO": "upcom:74100", "SGP": "upcom:74519", "SGS": "upcom:59992", "SHC": "upcom:76600", "SHG": "upcom:73299", "SHX": "upcom:75081", "SID": "upcom:75500", "SIG": "upcom:78801", "SII": "upcom:81621", "SIV": "upcom:76023", "SJC": "upcom:3144", "SJG": "upcom:76959", "SJM": "upcom:3664", "SKH": "upcom:76623", "SKN": "upcom:77780", "SKV": "upcom:76642", "SNC": "upcom:72799", "SNZ": "upcom:76647", "SP2": "upcom:75020", "SPB": "upcom:75123", "SPD": "upcom:54844", "SPH": "upcom:72619", "SPV": "upcom:75679", "SQC": "upcom:8084", "SRB": "upcom:4004", "SRT": "upcom:75300", "SSF": "upcom:54766", "SSG": "upcom:14436", "SSH": "upcom:80401", "SSN": "upcom:72359", "STH": "upcom:79163", "STL": "upcom:72399", "STS": "upcom:54845", "STT": "upcom:77500", "STW": "upcom:77460", "SVG": "upcom:74442", "SVH": "upcom:76824", "SWC": "upcom:64596", "SZE": "upcom:75382", "SZG": "upcom:80701", "TA3": "upcom:76861", "TA6": "upcom:76719", "TAN": "upcom:78400", "TAW": "upcom:74880", "TB8": "upcom:75499", "TBD": "upcom:72879", "TBH": "upcom:80422", "TBR": "upcom:81221", "TBT": "upcom:54726", "TCI": "upcom:77700", "TCJ": "upcom:76699", "TCK": "upcom:76625", "TCW": "upcom:76181", "TDB": "upcom:76284", "TDF": "upcom:79281", "TDS": "upcom:65996", "TED": "upcom:80941", "TEL": "upcom:76540", "TGP": "upcom:54027", "TH1": "upcom:7765", "THN": "upcom:76601", "THP": "upcom:78881", "THU": "upcom:76099", "THW": "upcom:74320", "TID": "upcom:77899", "TIE": "upcom:78679", "TIN": "upcom:80721", "TIS": "upcom:64836", "TKA": "upcom:79381", "TL4": "upcom:73139", "TLI": "upcom:78102", "TLP": "upcom:76779", "TLT": "upcom:72298", "TMG": "upcom:75623", "TMW": "upcom:54364", "TNB": "upcom:54846", "TNM": "upcom:54186", "TNP": "upcom:75410", "TNS": "upcom:75506", "TNW": "upcom:76025", "TOP": "upcom:73520", "TOS": "upcom:80441", "TOW": "upcom:78101", "TPS": "upcom:74000", "TQN": "upcom:75641", "TQW": "upcom:78439", "TR1": "upcom:79561", "TRS": "upcom:73721", "TRT": "upcom:75759", "TS3": "upcom:76881", "TS4": "upcom:80501", "TSD": "upcom:76865", "TSG": "upcom:75920", "TSJ": "upcom:76340", "TST": "upcom:3244", "TTD": "upcom:75642", "TTG": "upcom:54564", "TTN": "upcom:75919", "TTP": "upcom:75744", "TTS": "upcom:76039", "TUG": "upcom:75661", "TV1": "upcom:77400", "TV6": "upcom:80203", "TVA": "upcom:75900", "TVG": "upcom:54565", "TVH": "upcom:78060", "TVM": "upcom:74119", "TVN": "upcom:74221", "TVP": "upcom:76399", "TW3": "upcom:75122", "UCT": "upcom:75279", "UDC": "upcom:81641", "UDJ": "upcom:54424", "UDL": "upcom:79061", "UEM": "upcom:73723", "UMC": "upcom:76459", "UPC": "upcom:75921", "UPH": "upcom:75481", "USC": "upcom:75643", "USD": "upcom:78119", "V11": "upcom:69636", "V15": "upcom:8085", "VAB": "upcom:80381", "VAV": "upcom:76324", "VBB": "upcom:78639", "VBG": "upcom:75781", "VBH": "upcom:1782", "VC5": "upcom:3724", "VCE": "upcom:75480", "VCP": "upcom:75402", "VCR": "upcom:9204", "VCT": "upcom:61852", "VCW": "upcom:75321", "VCX": "upcom:72559", "VDB": "upcom:77921", "VDN": "upcom:54645", "VDT": "upcom:62692", "VE2": "upcom:11732", "VE9": "upcom:3744", "VEA": "upcom:77439", "VEC": "upcom:76303", "VEF": "upcom:74101", "VES": "upcom:73202", "VET": "upcom:76781", "VFC": "upcom:72277", "VFR": "upcom:1741", "VGG": "upcom:74339", "VGI": "upcom:77759", "VGL": "upcom:74920", "VGR": "upcom:77139", "VGT": "upcom:75485", "VGV": "upcom:76306", "VHD": "upcom:76200", "VHF": "upcom:54605", "VHG": "upcom:78359", "VHH": "upcom:10372", "VIE": "upcom:15656", "VIH": "upcom:75943", "VIM": "upcom:75586", "VIN": "upcom:72719", "VIR": "upcom:55144", "VIW": "upcom:76829", "VKC": "upcom:14196", "VKP": "upcom:72379", "VLB": "upcom:75019", "VLC": "upcom:73821", "VLF": "upcom:74599", "VLG": "upcom:73720", "VLP": "upcom:76305", "VLW": "upcom:76307", "VMA": "upcom:73659", "VMG": "upcom:76599", "VMT": "upcom:81525", "VNA": "upcom:76001", "VNB": "upcom:74819", "VNH": "upcom:75860", "VNI": "upcom:73419", "VNP": "upcom:73639", "VNX": "upcom:54344", "VNY": "upcom:77619", "VNZ": "upcom:81521", "VOC": "upcom:74999", "VPA": "upcom:74259", "VPC": "upcom:19156", "VPR": "upcom:75403", "VPW": "upcom:76660", "VQC": "upcom:54464", "VRG": "upcom:72959", "VSE": "upcom:77783", "VSF": "upcom:77179", "VSG": "upcom:72318", "VSN": "upcom:75163", "VST": "upcom:73440", "VTA": "upcom:67456", "VTD": "upcom:78841", "VTE": "upcom:77300", "VTG": "upcom:74179", "VTI": "upcom:63233", "VTK": "upcom:77979", "VTL": "upcom:7", "VTM": "upcom:74160", "VTP": "upcom:77919", "VTQ": "upcom:80141", "VTR": "upcom:78761", "VTS": "upcom:621", "VTX": "upcom:72599", "VUA": "upcom:80861", "VVN": "upcom:76620", "VVS": "upcom:81361", "VW3": "upcom:79261", "VWS": "upcom:75509", "VXB": "upcom:9024", "VXP": "upcom:78699", "VXT": "upcom:79341", "WSB": "upcom:61792", "WTC": "upcom:55304", "X26": "upcom:77479", "X77": "upcom:75621", "XDC": "upcom:81441", "XDH": "upcom:77799", "XHC": "upcom:75220", "XLV": "upcom:77279", "XMC": "upcom:3404", "XMD": "upcom:74139", "XMP": "upcom:80421", "XPH": "upcom:73019", "YBC": "upcom:4264", "YTC": "upcom:76341" }
let stock = {}
Object.keys(map).forEach(k => {
  let ex = map[k].split(":")
  stock[k] = ex[0];
})

let listEx = {
  hose: Object.keys(stock).filter(e => stock[e] == "hose"),
  upcom: Object.keys(stock).filter(e => stock[e] == "upcom"),
  hnx: Object.keys(stock).filter(e => stock[e] == "hnx"),
}

let mr = new MessageReader()
async function read() {

  mr.reader()
}
setTimeout(() => {
  read()
}, 10000);

setInterval(() => {
  priceModel.intervalCheck()
}, 5000)


function flattenObject(inputObject, parentKey = '') {
  let result = {};

  for (let key in inputObject) {
    if (typeof inputObject[key] === 'object' && !Array.isArray(inputObject[key])) {
      // Recursively flatten nested objects
      const flattened = flattenObject(inputObject[key], parentKey + key + '_');
      result = { ...result, ...flattened };
    } else {
      result[parentKey + key] = inputObject[key];
    }
  }

  return result;
}


let stockStore = {};
(() => {
  let data = fs.readFileSync('./stock.json');
  let stockData = JSON.parse(data);
  stockData.forEach(e => {
    stockStore[e.Symbol] = e;
  })
  console.log("Loaded stockStore!")
})();


let larger = ["VCB", "BID", "GAS", "VHM", "VIC", "HPG", "VPB", "VNM", "CTG", "FPT", "TCB", "MBB", "MSN", "ACB", "SAB", "GVR", "BCM", "MWG", "BSR", "MCH", "VJC", "SSB", "STB", "HDB", "VRE", "SSI", "VIB", "VEA", "PLX", "SHB", "TPB", "DGC", "EIB", "NVL", "LPB", "BVH", "OCB", "POW", "MSB", "PNJ", "VND", "KDH", "FOX", "KBC", "PGV", "HVN", "VGC", "REE", "GMD", "PDR", "GEX", "VCI", "HUT", "PVS", "IDC", "DCM", "KDC", "DIG", "NAB", "IDP", "PVD", "SHS", "NLG", "THD", "FRT", "DHG", "HCM", "HSG", "VPI", "VHC", "DPM", "VCG", "DXG", "KSF", "CEO", "EVF", "VIX", "LGC", "BAB", "PVI", "VSH", "SBT", "BHN", "CTR", "MBS", "VCS", "FTS", "BSI", "HAG", "TCH", "HDG", "DGW", "BWE", "PC1", "KOS", "PVT", "DTK", "BMP", "SJS", "CMG"]
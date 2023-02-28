import asyncio
import logging
from Exchange import Exchange

logging.basicConfig(level=logging.INFO)

async def main():
    symbol = "HPG"
    # result = await Exchange.transaction(symbol,2000000)
    # logging.info(result)
    # result = await Exchange.financial_report(symbol)
    # logging.info(result)    

    result = await Exchange.getlistallsymbol()
    logging.info(result)   
    result = await Exchange.getliststockdata(result)
    logging.info(result)   
    result = await Exchange.get_corporate()
    logging.info(result)       
if __name__ == "__main__":
    asyncio.run(main())

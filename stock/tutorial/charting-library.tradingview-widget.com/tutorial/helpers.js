// Make requests to CryptoCompare API
export async function makeApiRequest(path) {
	try {
		console.log("makeApiRequest " ,path );
		const response = await fetch(`https://min-api.cryptocompare.com/${path}`);
		var ret = response.json();
		console.log("makeApiRequest " ,ret );
		return ret;
	} catch (error) {
		throw new Error(`CryptoCompare request error: ${error.status}`);
	}
}

// Generate a symbol ID from a pair of the coins
export function generateSymbol(exchange, fromSymbol, toSymbol) {
	const short = `${fromSymbol}/${toSymbol}`;
	var ret = {
		short,
		full: `${exchange}:${short}`,
	};
	console.log("generateSymbol " ,ret );
	return ret;
}

export function parseFullSymbol(fullSymbol) {
	const match = fullSymbol.match(/^(\w+):(\w+)\/(\w+)$/);
	if (!match) {
		return null;
	}

	var ret = {
		exchange: match[1],
		fromSymbol: match[2],
		toSymbol: match[3],
	};
	console.log("parseFullSymbol " ,ret );
	return ret;
}

import {Injectable} from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {WebSocketService} from './websocket.service';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/filter';

const CHAT_URL = 'wss://3005-beige-scorpion-6mxxgdnd.ws-us25.gitpod.io/';
const DATA_URL = 'wss://3006-beige-scorpion-6mxxgdnd.ws-us25.gitpod.io/';
//https://3005-beige-scorpion-6mxxgdnd.ws-us25.gitpod.io/
// const CHAT_URL = 'https://3005-beige-scorpion-6mxxgdnd.ws-us25.gitpod.io/';
// const DATA_URL = 'https://3006-beige-scorpion-6mxxgdnd.ws-us25.gitpod.io/';
//3005-beige-scorpion-6mxxgdnd.ws-us25.gitpod.io

export interface Message {
	author: string,
	message: string,
	newDate?: string
}

@Injectable()
export class ChatService {
	public messages: Subject<Message>  = new Subject<Message>();
	public randomData: Subject<number> = new Subject<number>();

	constructor(private wsService: WebSocketService) {

		// 1. subscribe to chatbox
		this.messages   = <Subject<Message>>this.wsService
			.connect(CHAT_URL)
			.map((response: MessageEvent): Message => {
				let data = JSON.parse(response.data);
				return {
					author : data.author,
					message: data.message,
					newDate: data.newDate
				}
			});


		// 2. subscribe to random data
		this.randomData = <Subject<number>>this.wsService
			.connectData(DATA_URL)
			.map((response: any): number => {
				return response.data;
			})
	}
} // end class ChatService
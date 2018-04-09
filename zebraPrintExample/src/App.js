import React, { Component } from 'react';

import {
	AsyncStorage,
	Text,
	TextInput,
	TouchableOpacity,
	StyleSheet,
	Alert,
	View
} from 'react-native';

import ZebraBTPrinter from 'react-native-zebra-bt-printer';

const printLabel = async(userPrintCount, userText1, userText2, userText3) => {

	console.log('printLabel APP');

	if (userText1 === '') {
		Alert.alert('Your label seems to be missing content!');
		return false;
	}

	try {

		//Store your printer serial or mac, ios needs serial, android needs mac
		const printerSerial = await AsyncStorage.getItem('printerSerial');

		//check if printer is set
		if (printerSerial !== null && printerSerial !== '') {

			ZebraBTPrinter.printLabel(printerSerial, userPrintCount, userText1, userText2, userText3).then((result) => {

					console.log(result);

					if (result === false) {
						Alert.alert('Print failed, please check printer connection');
					}

				})
				.catch((err) => console.log(err.message));

		} else {

			Alert.alert('Print failed, no printer setup found');

		}

	} catch (error) {
		// Error retrieving data
		console.log('Async getItem failed');
	}

}

class App extends Component {

	constructor() {
		super();

		this.state = {
			userText1: '',
			userText2: '',
			userText3: '',
			userPrintCount: '1',
			printerSerial: ''
		};

	}

	componentDidMount() {

		//load mac address/serial of printer
		this.loadPrinterInfo();

	}

	loadPrinterInfo = async () => {

		try {

			const printerSerial = await AsyncStorage.getItem('printerSerial');

			console.log(printerSerial);

			if(printerSerial != null){
				this.setState({printerSerial:printerSerial});
			}
			

		} catch (error) {
			// Error retrieving data

		}

	}

	savePrinter = () => {

		if(this.state.printerSerial != ''){
			//write
			try {
				AsyncStorage.setItem('printerSerial', this.state.printerSerial);

				Alert.alert('Printer data saved');
				
			} catch (error) {
				//Error retrieving data
				console.log("AsyncStorage error = " + JSON.stringify(error))
			}
		} else {
			Alert.alert('Please enter printer info before saving');
		}
	}

	render() {

		return (
			<View style={styles.container}>
				<Text style={styles.welcome}>
					Welcome to React Native Zebra Printer Example!
				</Text>
				<Text style={styles.instructions}>
					Enter your printer Serial or Mac address and press save
				</Text>
				<TextInput
					value={ this.state.printerSerial }
					placeholder='Printer serial or mac'
					style={{borderWidth:1, borderColor:'grey', padding:3, width:200, backgroundColor:'white'}}
					onChange={ (text)=> this.setState({printerSerial:text}) }
				/>
				<TouchableOpacity 
				style={{borderWidth:1, borderColor:'grey', padding:3, width:100, backgroundColor:'white'}}
				onPress={ () => { 
					this.savePrinter(this.state.printerSerial);
				} }>
					<Text>Save Printer!</Text>
				</TouchableOpacity>

				<Text style={styles.instructions}>
					Now enter what you want to print and press print!
				</Text>
				<TextInput
					value={ this.state.userText1 }
					placeholder='Text1'
					style={{borderWidth:1, borderColor:'grey', padding:3, width:200, backgroundColor:'white'}}
					onChange={ (text)=> this.setState({userText1:text}) }
				/>
				<TextInput
					style={{borderWidth:1, borderColor:'grey', padding:3, width:200, backgroundColor:'white'}}
					value={ this.state.userText2 }
					placeholder='Text2'
					onChange={ (text)=> this.setState({userText2:text}) }
				/>
				<TextInput
					style={{borderWidth:1, borderColor:'grey', padding:3, width:200, backgroundColor:'white'}}
					value={ this.state.userText3 }
					placeholder='Text3'
					onChange={ (text)=> this.setState({userText3:text}) }
				/>
				<Text>
					How many to print?
				</Text>
				<TextInput
					style={{borderWidth:1, borderColor:'grey', padding:3, width:100, backgroundColor:'white'}}
					value={ this.state.userPrintCount }
					onChange={ (text)=> this.setState({userPrintCount:text}) }
				/>
				<TouchableOpacity 
				style={{borderWidth:1, borderColor:'grey', padding:3, width:100, backgroundColor:'white'}}
				onPress={ () => { 
					printLabel(this.state.userPrintCount, this.state.userText1, this.state.userText2, this.state.userText3);
				} }>
					<Text>Print!</Text>
				</TouchableOpacity>
			</View>
		);

	}

}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
		paddingBottom: 30,
		backgroundColor: '#F5FCFF',
	},
	welcome: {
		fontSize: 20,
		textAlign: 'center',
		margin: 10,
	},
	instructions: {
		textAlign: 'center',
		color: '#333333',
		marginBottom: 5,
	},
});

export default App;
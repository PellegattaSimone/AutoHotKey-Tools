<?php

	parse_str(implode('&', array_slice($argv, 1)), $_GET);	//convert command line variables to $_GET

	class Response {
		public string $text;	//requested text
		public string $language;	//detected language
		public int $confidence;	//how confident is the response
		public bool $reliable;	//is the response reliable?

		public function __construct(string $text, string $language = 'en', int $confidence = 0, bool $reliable = false) {
			$this->text = $text;
			$this->language = $language;	//defaults to english
			$this->confidence = $confidence;	//defaults to 0
			$this->reliable = $reliable;	//defaults to false
		}
	}

	class Curl {
		public static function exec(string $url, bool $post = false, ?array $fields = null) : string {
			$curl = curl_init();
			curl_setopt($curl, CURLOPT_URL, $url);
			curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);	//return API response using curl_exec()
			curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);	//no SSL certificates required

			if($post) {	//if post request required set fields
				curl_setopt($curl, CURLOPT_POST, 1);
				curl_setopt($curl, CURLOPT_POSTFIELDS, $fields);
			}

			$return = curl_exec($curl);

			if(curl_errno($curl))
				throw new ErrorException(curl_error($curl), 1, E_ERROR);	//if failure, throw exception

			curl_close($curl);

			return $return;
		}
	}

	class LanguageDetector {
		public string $accessKey;
		const URL = "https://ws.detectlanguage.com/0.2/detect";

		public function __construct(string $accessKey) {
			$this->accessKey = $accessKey;
		}

		private function error(string $error) : Response {
			return new Response(urlencode($error));	//set default language and display error message
		}

		public function detect(string $text) : Response {
			$post = ['key'=>$this->accessKey, 'q'=>$text];

			try {
				$response = json_decode(Curl::exec(self::URL, true, $post), false);	//make API request and decode API response

				if(isset($response->data)) {	//if response is successful
					$detection = $response->data->detections[0];	//take only the first detection
					return new Response($text, $detection->language, $detection->confidence, $detection->isReliable);
				}
				else
					$error = $response->error?->message ?? 'Unknown error: ' . print_r($response);	//display error message or unknown if no message
					return $this->error($error);
			}
			catch(ErrorException $e) {
				return $this->error($e->getMessage());	//display curl error message
			}
		}
	};

	// define("ACCESS_KEY", "demo");	//default access key
	define("ACCESS_KEY", "51dbf59e49dc2b613d13c1b272360db7");	//found at https://detectlanguage.com/private (simopelle04@gmail.com)

	if(isset($_GET['text'])) {
		$text = urlencode($_GET['text']);

		$driver = new LanguageDetector(ACCESS_KEY);	//create a new detector
		$response = $driver->detect($text);	//detect language via the API

		$language = $response->language == 'it' ? 'en' : 'it';	//if text is in italian translate to english, else to italian

		// exec("start https://translate.google.com?sl=auto^&tl=$language^&text={$response->text}");
		exec("start https://translate.google.com?sl={$response->language}^&tl=$language^&text={$response->text}");
	}
	else
		exec("start https://translate.google.com?sl=auto^&tl=en");
const express = require("express");
const cors = require("cors");
const { MongoClient } = require("mongodb");
const app = express();
const PORT = 3000;
// const TRUSTED_IPS = ["123.456.78.90", "::1"]; // Replace with Roblox proxy IPs or your IP

app.use(express.json());
app.use(cors());

const uri = "mongodb+srv://huebert:12345@cluster0.t0bp3l9.mongodb.net/"; // replace
const client = new MongoClient(uri);
let db;

client.connect().then(() => {
  db = client.db("mydb");
  console.log("Connected to MongoDB");
});

// change later to use a more secure secret
const API_TOKEN = "s3cr3t-t0k3n-1234567890";

function token(req, res, next) {
	const auth = req.headers["authorization"];
	if (!auth || auth !== `Bearer ${API_TOKEN}`) {
		return res.status(403).json({ error: "Forbidden: Invalid API token" });
	}
	next();
}

// change to validation and HMAC
app.post("/addPlayer", token, async (req, res) => {
  const body = req.body;
  const userid = body.userid;
  console.log("Received request to add player with userid:", userid);
  console.log("DB status:", db ? "Connected" : "NOT connected");
  try {
	if(await db.collection("players").findOne({ userid })) {
		return res.status(400).json({ error: "Player already exists" });
	}
	
    await db.collection("players").insertOne({ userid });
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get("/", token, (req, res) => {
	res.send("Hello World!");
});

app.listen(PORT, () => {
	console.log("Server listening on port", PORT);
});

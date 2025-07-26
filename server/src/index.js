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

app.get("/", token, (req, res) => {
	res.send("Hello World!");
});

app.get("/get", token, async (req, res) => {
	  const key = Number(req.query.userid);
  if (!key) {
    return res.status(400).send("Missing key");
  }

  console.log("Received request to get value for key:", key);

  // Your DB logic here
//   res.json({ key, value: "example value" });
  try {
	const collection = db.collection("players");
	const result = await collection.findOne({ userid: key });
	console.log("DB result:", result);
	if (result) {
		console.log("Found value:", result);
		res.json({ result });
	} else {
		res.status(404).send("Not Found");
	}
  } catch (error) {
	console.error("Error fetching data:", error);
	res.status(500).send("Internal Server Error");
	}
});

app.post("/set", token, async (req, res) => {
  console.log("Received request:", req.body[0]);
  const userid = Number(req.body[0]);
  const payload = req.body[1];

  if (!userid || !payload) {
	return res.status(400).send("Missing userid or payload");
  }

  console.log("Received request to set value for userid:", userid, "with payload:", payload);
  try {
	const collection = db.collection("players");
	const result = await collection.updateOne(
	  { userid: userid },
	  { $set: { data: payload } },
	  { upsert: true }
	);
	// if (result.modifiedCount > 0 || result.upsertedCount > 0) {
	//   console.log("Value set successfully");
	//   res.json({ success: true });
	// } else {
	//   console.log("No changes made to the database");
	//   res.status(304).send("Not Modified");
	// }
	res.json({ success: true });
  } catch (error) {
	console.error("Error setting data:", error);
	res.status(500).send("Internal Server Error");
  }
});

app.listen(PORT, () => {
	console.log("Server listening on port", PORT);
});

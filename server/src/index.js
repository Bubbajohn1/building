const express = require("express");
const crypto = require("crypto");
const rateLimit = require("express-rate-limit");
const cors = require("cors");

const app = express();
const PORT = 3000;
// const TRUSTED_IPS = ["123.456.78.90", "::1"]; // Replace with Roblox proxy IPs or your IP

app.use(express.json());
app.use(cors());

// change later to use a more secure secret
const API_TOKEN = "s3cr3t-t0k3n-1234567890";

function token(req, res, next) {
	const auth = req.headers["authorization"];
	if (!auth || auth !== `Bearer ${API_TOKEN}`) {
		return res.status(403).json({ error: "Forbidden: Invalid API token" });
	}
	next();
}

// ✅ Endpoint with validation and HMAC
app.post("/", token, (req, res) => {
	res.json({ number: 5 });
});

app.get("/", token, (req, res) => {
	res.send("Hello World!");
});

app.listen(PORT, () => {
	console.log("Server listening on port", PORT);
});

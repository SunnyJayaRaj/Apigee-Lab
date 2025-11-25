# 🧪 Apigee Lab & API Playground

**Status:** ✅ Completed (v1.0)

Welcome to my digital laboratory! This repository documents my journey to mastering **Google Cloud Apigee**. This project is a fully functional API Proxy bundle that demonstrates API security, traffic management, and data mediation.

## 🛠 Tech Stack
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Apigee](https://img.shields.io/badge/Apigee-MX-red?style=for-the-badge)
![OpenAPI](https://img.shields.io/badge/OpenAPI-6BA539?style=for-the-badge&logo=openapi-initiative&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white)

## 📂 Repository Structure & Logic

| Folder | Component | Function |
| :--- | :--- | :--- |
| **`01-API-Design`** | `weather-api-v1.yaml` | OpenAPI 3.0 Spec defining the contract. |
| **`02-Mediation`** | `XML-to-JSON` | Converts legacy XML backend responses to modern JSON. |
| **`03-Security`** | `Spike-Arrest` | Protects against DDoS attacks (12pm rate limit). |
| **`03-Security`** | `Verify-API-Key` | Authenticates client apps via query parameter. |
| **`04-Monetization`** | `Quota-Silver` | Enforces a 2000 calls/month limit per user. |
| **`05-Proxy-Wiring`** | **Endpoints** | Connects all policies into a logical execution flow. |
| **Root** | `weather-proxy.xml` | The main configuration manifest for deployment. |

## 🔄 Proxy Logic Flow
1.  **Inbound Request:** Client calls `/weather-lab`.
2.  **PreFlow:**
    * ⛔️ **Spike Arrest:** Stops traffic surges.
    * 🔑 **Verify Key:** Checks `?apikey=...`.
    * 📉 **Quota:** Deducts 1 credit from the user's Silver Tier.
3.  **Target:** Request forwarded to `api.example.com`.
4.  **PostFlow:**
    * ✨ **XML to JSON:** Backend response is formatted for the client.
5.  **Response:** Client receives clean JSON data.

---
*Created by [Sunny JayaRaj](https://sunnyjayaraj.github.io)*

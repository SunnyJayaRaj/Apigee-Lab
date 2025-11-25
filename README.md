# 🧪 Apigee Lab: Weather API Proxy

![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge)

Welcome to my digital laboratory! This repository documents my journey to mastering **Google Cloud Apigee**. This project represents a fully functional API Proxy bundle that demonstrates enterprise-grade API security, traffic management, and data mediation.

## 🚀 Project Overview
This proxy acts as a managed gateway for a backend Weather Service. It enforces security policies and transforms data before it reaches the client.

### 🛠 Tech Stack
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Apigee](https://img.shields.io/badge/Apigee-MX-red?style=for-the-badge)
![OpenAPI](https://img.shields.io/badge/OpenAPI-6BA539?style=for-the-badge&logo=openapi-initiative&logoColor=white)
![XML](https://img.shields.io/badge/XML-Configuration-orange?style=for-the-badge)

## 📂 Architecture & Logic

The repository is structured to separate concerns (Security, Mediation, Monetization).

| Component | Policy / File | Function |
| :--- | :--- | :--- |
| **Contract** | `01-API-Design` | **OpenAPI 3.0 Spec** defining the API surface and data models. |
| **Security** | `Spike-Arrest` | **DDoS Protection:** Limits traffic spikes to protect backend infrastructure. |
| **Security** | `Verify-API-Key` | **Authentication:** Validates client credentials via Query Parameter. |
| **Governance** | `Quota-Silver` | **Monetization:** Enforces a hard limit of 2,000 calls/month per user. |
| **Mediation** | `XML-to-JSON` | **Transformation:** Converts legacy XML backend responses to modern JSON. |
| **Wiring** | `05-Proxy-Wiring` | **Flow Logic:** Chains policies together in the `PreFlow` and `PostFlow`. |

## 🔄 Execution Flow
When a client makes a request to `/weather-lab`:

1.  **Request Ingest:** Apigee intercepts the call.
2.  **PreFlow Logic:**
    * ⛔️ **Spike Arrest** checks for traffic surges.
    * 🔑 **API Key Validation** ensures the user is authorized.
    * 📉 **Quota Check** deducts 1 credit from the "Silver Tier" bucket.
3.  **Backend Routing:** Request is forwarded to `https://api.example.com/v1`.
4.  **PostFlow Logic:**
    * ✨ **XML to JSON** runs on the response to sanitize the output.
5.  **Final Response:** Client receives clean JSON data.

---
### ☁️ Deployment
*This project follows the standard Apigee XML structure.*
To deploy this bundle:
1.  Zip the root directory.
2.  Import as a new Proxy in the **Google Cloud Apigee Console**.
3.  Deploy to the `test` environment.

---
*Developed by [Sunny JayaRaj](https://github.com/SunnyJayaRaj)*

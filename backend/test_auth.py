import asyncio
import httpx

async def test_auth_flow():
    async with httpx.AsyncClient(base_url="http://127.0.0.1:8000/api/v1") as client:
        print("1. Registering user...")
        res = await client.post("/auth/register", json={
            "email": "test@example.com",
            "password": "Password123!",
            "name": "Test Parent"
        })
        print(res.status_code, res.text)
        
        if res.status_code == 200:
            token = res.json()["access_token"]
            print("2. Creating child profile...")
            headers = {"Authorization": f"Bearer {token}"}
            child_res = await client.post("/children/", json={
                "name": "Ali",
                "age": 8,
                "preferred_language": "ar",
                "grade_level": "Grade 3",
                "preferred_subjects": ["Science", "Math"]
            }, headers=headers)
            print(child_res.status_code, child_res.text)

if __name__ == "__main__":
    asyncio.run(test_auth_flow())

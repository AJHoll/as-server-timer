import { useEffect } from "react";
import { useNavigate } from "react-router-dom";

export default function MainPage() {
  const navigate = useNavigate();
  useEffect(() => {
    const webSocketKey = window.localStorage.getItem("userAccessKey");
    console.log(webSocketKey, window.localStorage);
    if (!webSocketKey) {
      navigate("/auth");
    }
  });

  return (
    <>
      <h1>Hello this a main page</h1>
    </>
  );
}

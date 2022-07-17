import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { AuthPage, ClientTimerPage, ConfigTimerPage, MainPage } from "../Pages";

export default function AppRouter(props: any) {
  return (
    <>
      <Router>
        <Routes>
          <Route path="/" element={<MainPage />} />
          <Route path="/auth" element={<AuthPage />} />
          <Route path="/client-timer" element={<ClientTimerPage />} />
          <Route path="/config-timer" element={<ConfigTimerPage />} />
        </Routes>
      </Router>
    </>
  );
}

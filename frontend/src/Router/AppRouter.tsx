import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { AuthPage, ClientTimerPage, ConfigTimerPage, MainPage } from "../Pages";

export default function AppRouter(props: any) {
  return (
    <>
      <Router>
        <Routes>
          <Route path="/" element={<MainPage {...props} />} />
          <Route path="/auth" element={<AuthPage {...props} />} />
          <Route
            path="/client-timer"
            element={<ClientTimerPage {...props} />}
          />
          <Route
            path="/config-timer"
            element={<ConfigTimerPage {...props} />}
          />
        </Routes>
      </Router>
    </>
  );
}

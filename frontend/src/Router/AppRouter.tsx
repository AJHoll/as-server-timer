import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import { AuthPage, ClientTimerPage, ConfigTimerPage, MainPage } from "../Pages";

export default class AppRouter extends React.Component<any> {
  render(): React.ReactNode {
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
}

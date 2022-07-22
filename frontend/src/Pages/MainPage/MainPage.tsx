import Button from "antd/lib/button";
import Col from "antd/lib/col";
import Row from "antd/lib/row";
import React from "react";
import { ReactNode, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./MainPage.css";

export class MainPageClass extends React.Component<any> {
  state = {
    timerCounter: 0,
    timerInterval: undefined,
  };

  componentDidMount() {}

  render(): ReactNode {
    return (
      <div className="app-layout-center">
        <div className="app-main-page-container">
          <div className="app-main_page_container__footer">
            <Row justify="center" align="middle" gutter={15}>
              <Col>
                <Button
                  size="large"
                  children="Активные таймеры"
                  onClick={() => {
                    this.props.navigate("/client-timer");
                  }}
                />
              </Col>
              <Col>
                <Button
                  size="large"
                  children="Конфигурация таймеров"
                  onClick={() => {
                    this.props.navigate("/config-timer");
                  }}
                />
              </Col>
            </Row>
          </div>
        </div>
      </div>
    );
  }
}

export default function MainPage(props: any) {
  const navigate = useNavigate();
  useEffect(() => {
    const webSocketKey = window.localStorage.getItem("userAccessKey");
    if (!webSocketKey) {
      navigate("/auth");
    }
  });
  return <MainPageClass navigate={navigate} />;
}

import Card from "antd/lib/card/Card";
import Form from "antd/lib/form";
import Input from "antd/lib/input";
import "./AuthPage.css";
import { UserOutlined, LockOutlined } from "@ant-design/icons";
import Button from "antd/lib/button";
import { useNavigate } from "react-router";
import AuthPageService from "./AuthPageService";
import { message } from "antd";

const authPageService = new AuthPageService();

export default function AuthPage(props: any) {
  const navigate = useNavigate();
  return (
    <div className="app-layout-center">
      <Card
        title="Авторизация"
        style={{ width: 500, boxShadow: "0px 0px 30px 0px rgb(0 0 0 / 20%)" }}
        bordered
      >
        <Form
          name="login"
          className="login-form"
          onFinish={async (values) => {
            const retVal = await authPageService.signIn(
              values.username,
              values.password
            );
            if (retVal.status === "error") {
              // message.error("Что то пошло не так");
            }
          }}
        >
          <Form.Item
            name="username"
            rules={[
              {
                required: true,
                message: "Введите имя пользователя!",
              },
            ]}
          >
            <Input
              prefix={<UserOutlined className="site-form-item-icon" />}
              placeholder="Имя пользователя"
              autoFocus
            />
          </Form.Item>
          <Form.Item
            name="password"
            rules={[
              {
                required: true,
                message: "Введите пароль!",
              },
            ]}
          >
            <Input
              prefix={<LockOutlined className="site-form-item-icon" />}
              type="password"
              placeholder="Пароль"
            />
          </Form.Item>
          <Form.Item>
            <Button
              type="primary"
              htmlType="submit"
              className="login-form-button"
              children="Войти"
            />
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
}

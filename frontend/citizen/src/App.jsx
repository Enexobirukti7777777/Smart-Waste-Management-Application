import { BrowserRouter, Routes, Route } from "react-router-dom";

import MainLayout from "./layouts/MainLayout";
import Dashboard from "./pages/Dashboard";
import CreateRequest from "./pages/CreateRequest";
import MyRequests from "./pages/MyRequests";
import ChatBot from "./pages/Chatbot";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Layout wrapper */}
        <Route path="/" element={<MainLayout />}>
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="create-request" element={<CreateRequest />} />
          <Route path="requests" element={<MyRequests />} />
          <Route path="chatbot" element={<ChatBot />} />
          Route
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;

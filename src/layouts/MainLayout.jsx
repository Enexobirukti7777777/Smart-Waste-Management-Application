import { useState } from "react";
import { Outlet } from "react-router-dom";
import Navbar from "../components/layout/Navbar";
import Sidebar from "../components/layout/Sidebar";

const MainLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const toggleSidebar = () => setSidebarOpen((prev) => !prev);

  return (
    <>
      {/* Sidebar */}
      <Sidebar show={sidebarOpen} onHide={() => setSidebarOpen(false)} />

      {/* Main Content Area */}
      <div className="d-flex flex-column flex-grow-1">
        <Navbar onMenuClick={toggleSidebar} />
        <main className="main-content flex-grow-1">
          <Outlet />
        </main>
      </div>
    </>
  );
};

export default MainLayout;

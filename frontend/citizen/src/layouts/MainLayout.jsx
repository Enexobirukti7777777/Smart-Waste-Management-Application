import Navbar from "../components/layout/Navbar";
import { Outlet } from "react-router-dom"; // <-- important

const MainLayout = () => {
  return (
    <div>
      <Navbar />
      <main>
        <Outlet /> {/* <-- this is where child pages render */}
      </main>
    </div>
  );
};

export default MainLayout;

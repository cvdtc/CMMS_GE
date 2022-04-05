import React, { Component } from "react";
/// import react bootstrap
import {
  Navbar,
  Container,
  Nav,
  Offcanvas,
  NavDropdown,
} from "react-bootstrap";
/// import react router dom
import { Link } from "react-router-dom";

class NavbarComponent extends Component {
  render() {
    return (
      <div>
        <Navbar bg="light" expand={false}>
          <Container fluid>
            <Navbar.Brand href="/dashboard">
              <img
                alt=""
                src="/assets/logo-ge.png"
                width="125"
                height="35"
                className="d-inline-block align-top"
              />{' '}
              CMMS GE
            </Navbar.Brand>
            <Navbar.Toggle aria-controls="offcanvasNavbar" />
            <Navbar.Offcanvas
              id="offcanvasNavbar"
              aria-labelledby="offcanvasNavbarLabel"
              placement="end"
            >
              <Offcanvas.Header closeButton>
                <Offcanvas.Title id="offcanvasNavbarLabel">
                  Menu
                </Offcanvas.Title>
              </Offcanvas.Header>
              <Offcanvas.Body>
                <Nav className="justify-content-end flex-grow-1 pe-3">
                  <Nav.Link as={Link} to="/dashboard">Dashboard</Nav.Link>
                  <NavDropdown title="Master" id="offcanvasNavbarDropdown">
                    <NavDropdown.Item as={Link} to="/datakomponen">Komponen</NavDropdown.Item>
                    <NavDropdown.Item as={Link} to="/datamesin">Mesin</NavDropdown.Item>
                    <NavDropdown.Item as={Link} to="/datasite">Sites</NavDropdown.Item>
                    {/* <NavDropdown.Divider /> */}
                  </NavDropdown>
                  <NavDropdown title="Transaksi" id="offcanvasNavbarDropdown">
                    <NavDropdown.Item as={Link} to="/datapreactivity">Pre-Activity</NavDropdown.Item>
                    <NavDropdown.Item as={Link} to="/dataactivity">Activity</NavDropdown.Item>
                    <NavDropdown.Item href="#action4">Schedule</NavDropdown.Item>
                    <NavDropdown.Item as={Link} to="/datachecklist">Checklist</NavDropdown.Item>
                  </NavDropdown>
                  <NavDropdown title="Laporan" id="offcanvasNavbarDropdown">
                    <NavDropdown.Item href="#action3">Stok Barang</NavDropdown.Item>
                  </NavDropdown>
                </Nav>
              </Offcanvas.Body>
            </Navbar.Offcanvas>
          </Container>
        </Navbar>
      </div>
    );
  }
}

export default NavbarComponent;

import React, { Component } from 'react';
/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// import react router dom
import { Link } from 'react-router-dom'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

/// import axios 
import axios from '../../../utils/server';
import swal from 'sweetalert';

class Dataproduksi extends Component {
    constructor(props) {
        super(props)
        this.state = {
            /// modal handler show or hide
            showmodal: true,
            /// state for data site
            dataProduksi: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "Tanggal",
                    field: 'periode',
                },
                {
                    headerName: "No. Prod",
                    field: 'No_Produksi',
                },
                {
                    headerName: "Mould",
                    field: 'No_Mould',
                },
                {
                    headerName: "SidePI",
                    field: 'plate',
                },
                {
                    headerName: "Dry Dens",
                    field: 'SS_Density',
                },
                {
                    headerName: "SS (p)",
                    field: 'S_Slurry',
                },
                {
                    headerName: "SS Target (p)",
                    field: 'SS_Target',
                },
                {
                    headerName: "WS (p)",
                    field: 'W_Slurry',
                },
                {
                    headerName: "WS Target",
                    field: 'WS_Target',
                },
                {
                    headerName: "Water",
                    field: 'Water',
                },
                {
                    headerName: "Cement",
                    field: 'Cement',
                },
                {
                    headerName: "Cement Target",
                    field: 'Cement_Target',
                },
                {
                    headerName: "Lime",
                    field: 'Lime',
                },
                {
                    headerName: "Lime Target",
                    field: 'Lime_Target',
                },
                {
                    headerName: "Alu",
                    field: 'Alumunium',
                },
                {
                    headerName: "Formula",
                    field: 'FC',
                },
                {
                    headerName: "Temp",
                    field: 'Temperature',
                }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: true,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }

    /// init state
    componentDidMount() {
        try { 
            this.interval = setInterval(async () => {
                console.log('call api')
                await axios.get("dataproduksi3", {
                    headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
                }).then((response) => {
                    console.log(response.data.data)
                    this.setState({ dataProduksi: response.data.data[0]})
                }).catch((error) => {
                    swal(`Sorry! ${error.response.message}`, {
                        icon: "error",
                    });
                }).finally(() => {
                    this.setState({ loading: false })
                })
            }, 5000)
        } catch (e) {
            console.log(e)
        }
    }
    
    componentWillUnmount() {
        console.log("updated")
        clearInterval(this.interval)
    }


    render() {
        return (
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                <div className="md:container md:mx-auto mt-3">
                    <div className='grid grid-cols-6 gap-4 '>
                        <div className='col-start-1 col-end-3'>
                            {/* /// name page */}
                            <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                                Data Site
                            </h1>
                        </div>
                        {/* /// button tambah */}
                        <div className='col-end-7 col-span-1'>
                            <div className="flex-auto justify-center items-center mt-6">
                                <Link to='/addsite'>
                                    <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-700">Tambah Site</button>
                                </Link>

                            </div>
                        </div>
                        <p>Data update per 5000 ms</p>
                    </div>
                    {/* /// condition to load data grid komponent */}
                    <div className='ag-theme-alpine' style={{ height: '100vh' }}>
                        <AgGridReact
                            suppressExcelExport={true}
                            rowData={this.state.dataProduksi}
                            columnDefs={this.state.columnDefs}
                            animateRows={true}
                            gridOptions={this.state.gridOptions}
                            defaultColDef={this.state.defaultColDef}
                            loadingCellRendererParams={this.state.loadingCellRendererParams}
                        />
                    </div>
                </div>
            </>
        );
    }
}

export default Dataproduksi;

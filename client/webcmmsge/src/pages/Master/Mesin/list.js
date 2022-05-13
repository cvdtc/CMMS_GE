import React from 'react';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar"

/// react router dom
import { Link } from 'react-router-dom'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css'
import 'ag-grid-community/dist/styles/ag-theme-alpine.css'
import swal from 'sweetalert';

/// import axios 
import axios from '../../../utils/server';
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            /// state for data mesin
            dataMesin: [],
            loading: true,
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "No. Mesin",
                    field: 'nomesin',
                },
                {
                    headerName: "Keterangan",
                    field: 'keterangan',
                },
                {
                    headerName: "Site",
                    field: 'site',
                },
                {
                    headerName: 'Action',
                    field: 'idmesin',
                    // cellRendererFramework:(params) => <div><button className='btn btn-success' onClick={() => actionButton(params.data.idmesin)}>Ubah</button></div>
                    cellRendererFramework: (params) => <div className='inline-flex rounded-md' role='group'><Link to='/editmesin/' state={{data: params.data}} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link><button onClick={()=>this.KonfirmHapusData(params)} className="py-2 px-2 text-sm font-small rounded-r-lg border border-gray-300 bg-red-500 text-white">Delete</button></div>
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
    async componentDidMount() {
        await this.getDataMesin()
    }

    async KonfirmHapusData(params){
        swal({
            title: `Yakin Akan Menghapus Data ${params.data.nomesin}?`,
            text: "Pastikan data yang anda hapus sudah sesuai!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
            closeOnClickOutside: false,
            closeOnEsc: false,
        }).then((willDelete) => {
                if (willDelete) {
                    this.HapusData(params.data.idmesin)
                }
            });
    }

    async HapusData(idmesin){
        await axios.delete("mesin/" + idmesin, {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            swal(`${response.data.message}`, {
                icon: "success",
            });
            this.getDataMesin();
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    /// getting data mesin from api
    async getDataMesin() {
        this.setState({ loading: true })
        axios.get("mesin/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ dataMesin: response.data.data })
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
            this.setState({ loading: false })
        })
    }

    render() {
        return (
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                {/* <SideBar/> */}
                <div className="md:container md:mx-auto mt-3">
                    <div className='grid grid-cols-6 gap-4 '>
                        <div className='col-start-1 col-end-3'>
                            {/* /// name page */}
                            <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                                Data Mesin
                            </h1>
                        </div>
                        {/* /// button tambah */}
                        <div className='col-end-7 col-span-1'>
                            <div className="flex-auto justify-center items-center mt-6">
                                <Link to={'/addmesin'}>
                                    <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-700">Tambah Mesin</button>
                                </Link>
                            </div>
                        </div>
                    </div>
                    {/* /// table data grid */}
                    <div className='ag-theme-alpine' style={{ height: '100vh' }}>
                        <AgGridReact
                            suppressExcelExport={true}
                            rowData={this.state.dataMesin}
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

export default List;
